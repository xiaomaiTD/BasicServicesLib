//
//  URLSessionTask.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionTask.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Macros.h"
#import "URLSessionTaskPool.h"

@interface URLSessionTask ()

@property(strong, nonatomic) NSURLSessionDataTask *task;
@property(assign, nonatomic) URLSessionTaskState state;
@property(copy, nonatomic) URLSessionTaskProgress progress;
@property(copy, nonatomic) URLSessionTaskSuccess success;
@property(copy, nonatomic) URLSessionTaskFailure failure;

@end

@implementation URLSessionTask
@synthesize URL = _URL;

static NSString *get_methodFrom(URLSessionTaskMethod method)
{
    switch (method)
    {
        case URLSessionTaskMethodPOST:
            return @"POST"; break;
        case URLSessionTaskMethodGET:
            return @"GET"; break;
        case URLSessionTaskMethodPUT:
            return @"PUT"; break;
        case URLSessionTaskMethodHEAD:
            return @"HEAD"; break;
        case URLSessionTaskMethodPATCH:
            return @"PATCH"; break;
        case URLSessionTaskMethodDELETE:
            return @"DELETE"; break;
        case URLSessionTaskMethodMULTIPART_FORM:
            return @"MULTIPART"; break;
    }
}

static char * const kSuccessInterruptorAssociateKey = "\0";
+ (void)setSuccessInerruptor:(URLSessionTaskSuccessInterruptor)interruptor
{
    if (interruptor)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objc_setAssociatedObject(self, kSuccessInterruptorAssociateKey, interruptor, OBJC_ASSOCIATION_COPY);
        });
    }
}

- (URLSessionTaskSuccessInterruptor)getInterruptor
{
    return objc_getAssociatedObject([self class], kSuccessInterruptorAssociateKey);
}

static char * const kHTTPSCerPathAssociateKey = "\1";
+ (void)setHTTPSCerPath:(NSString *)path
{
    if (path) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objc_setAssociatedObject(self, kHTTPSCerPathAssociateKey, path, OBJC_ASSOCIATION_COPY);
        });
    }
}

- (NSString *)getHTTPSCerPath
{
    return objc_getAssociatedObject([self class], kHTTPSCerPathAssociateKey);
}

- (instancetype)initWithURL:(URLSessionTaskURL *)URL progress:(URLSessionTaskProgress)progress success:(URLSessionTaskSuccess)success failure:(URLSessionTaskFailure)failure
{
    if (self = [super init])
    {
        _URL = URL;
        _state = URLSessionTaskStateWait;
        _method = URLSessionTaskMethodPOST;
        _timeout = 30.f;
        _progress = progress;
        _success = success;
        _failure = failure;
    }
    return self;
}

- (void)dealloc
{
    DEV_LOG(@"URLSessionTask have dealloced.");
}

- (URLSessionTaskState)state
{
    return _state;
}

- (void)send
{
    if (_state == URLSessionTaskStateWait)
    {
        // 取消相同的请求并添加到请求池中
        _state = URLSessionTaskStateReady;
        NSArray *runningTasks = [URLSessionTaskPool pool].runningTasks;
        for (int idx = 0; idx < runningTasks.count; ++ idx)
        {
            URLSessionTask *task = runningTasks[idx];
            if ([task.params isEqual:self.params] && [task.URL isEqual:self.URL]) {
                [task cancel];
            }
        }
        [[URLSessionTaskPool pool] addTask:self];
        
        // 开始请求
        _state = URLSessionTaskStateRunning;
        [self _send];
        [_task resume];
    }
}

- (void)cancel
{
    _state = URLSessionTaskStateCancel;
    [self.task cancel];
    [[URLSessionTaskPool pool] removeTask:self];
}

- (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 请求编码
    if (self.params.serializer == URLSessionTaskSerializerJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else if (self.params.serializer == URLSessionTaskSerializerSTRING)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    
    // 设置请求头
    if (self.params.header != nil)
    {
        [self.params.header enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    manager.requestSerializer.timeoutInterval = _timeout;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    return manager;
}

- (void)_send
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    // 准备参数
    NSString *url = _URL.URLString;
    if ([url hasPrefix:@"https"]) {
        [self setupHTTPSWithManager:manager];
    }
    id parameter = _params.params;
    SEL selector = NULL;
    NSString *method = get_methodFrom(_method);
    void (^uploadProgressBlock) (NSProgress *uploadProgress) = ^ (NSProgress *uploadProgress) {
        if (self.progress) {
            self.progress(uploadProgress.fractionCompleted);
        }
    };
    void (^successBlock) (NSURLSessionDataTask *task, id responseObject) = ^ (NSURLSessionDataTask *task, id responseObject) {
        URLSessionTaskResponse *response = [[URLSessionTaskResponse alloc] initWithResponse:responseObject class:self.transferCls];
        URLSessionTaskSuccessInterruptor interruptor = [self getInterruptor];
        if (interruptor) {
            interruptor(response);
        }
        
        if (self.success) {
            self.success(response);
        }
        self.state = URLSessionTaskStateCompleted;
        [[URLSessionTaskPool pool] removeTask:self];
    };
    void (^failureBlock) (NSURLSessionDataTask * task, NSError *error) = ^ (NSURLSessionDataTask * task, NSError *error) {
        if (self.failure) {
            self.failure(error);
        }
        
        if (task.error.code != NSURLErrorCancelled) {
            self.state = URLSessionTaskStateCompleted;
        }
        
        [[URLSessionTaskPool pool] removeTask:self];
    };
    
    // 发送请求
    if ([method isEqualToString:@"MULTIPART"])
    {
        void (^ formDataBlock) (id<AFMultipartFormData> formData) = ^ (id<AFMultipartFormData> formData) {
            if (self.formData) {
                self.formData(formData);
            }
        };
        
        selector = NSSelectorFromString(@"POST:parameters:constructingBodyWithBlock:progress:success:failure:");
        if ([manager respondsToSelector:selector])
        {
            NSURLSessionDataTask * (*function) (AFHTTPSessionManager *, SEL, NSString *, id, void (^) (id<AFMultipartFormData>), void (^) (NSProgress *), void (^) (NSURLSessionDataTask *, id), void (^) (NSURLSessionDataTask *, NSError *)) = (void *)objc_msgSend;
            _task = function(manager, selector, url, parameter, formDataBlock, uploadProgressBlock, successBlock, failureBlock);
        }
    }
    else
    {
        selector = NSSelectorFromString(@"dataTaskWithHTTPMethod:URLString:parameters:uploadProgress:downloadProgress:success:failure:");
        if ([manager respondsToSelector:selector])
        {
            NSURLSessionDataTask * (*function) (AFHTTPSessionManager *, SEL, NSString *, NSString *, id, void (^) (NSProgress *), void (^) (NSProgress *), void (^) (NSURLSessionDataTask *, id), void (^) (NSURLSessionDataTask *, NSError *)) = (void *)objc_msgSend;
            _task = function(manager, selector, method, url, parameter, uploadProgressBlock, NULL, successBlock, failureBlock);
        }
    }
}

/// refer from: https://www.jianshu.com/p/97745be81d64
- (void)setupHTTPSWithManager:(AFHTTPSessionManager *)manager
{
    NSString *cerPath = [self getHTTPSCerPath];
    if (cerPath != nil)
    {
        // 设置证书模式
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    else
    {
        // 设置非校验证书模式
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }
}

@end
