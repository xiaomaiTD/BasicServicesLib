//
//  URLSessionChainTask.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/12.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionChainTask.h"
#import "Macros.h"

@interface URLSessionChainTask ()

@property(strong, nonatomic) NSMutableArray<URLSessionTaskURL*> *chainTaskURLs;
@property(copy, nonatomic) URLSessionChainTaskPrepare prepare;
@property(copy, nonatomic) URLSessionChainTaskProgress progress;
@property(copy, nonatomic) URLSessionChainTaskSuccess success;
@property(copy, nonatomic) URLSessionChainTaskFailure failure;

@end

@implementation URLSessionChainTask
@synthesize state = _state;

/// 用于管理链式请求的队列
- (NSMutableArray *)chainQueue
{
    static dispatch_once_t onceToken;
    static NSMutableArray<URLSessionChainTask*> *array = nil;
    dispatch_once(&onceToken, ^{
        array = [NSMutableArray array];
    });
    return array;
}

- (instancetype)initWithPrepare:(URLSessionChainTaskPrepare)prepare progress:(URLSessionChainTaskProgress)progress success:(URLSessionChainTaskSuccess)success failure:(URLSessionChainTaskFailure)failure
{
    if (self = [super init])
    {
        _state = URLSessionChainTaskStateWait;
        _chainTaskURLs = [NSMutableArray array];
        _prepare = prepare;
        _progress = progress;
        _success = success;
        _failure = failure;
    }
    
    return self;
}

- (void)dealloc
{
    DEV_LOG(@"URLSessionChainTask have dealloced.");
}

- (void)addTaskURL:(URLSessionTaskURL *)URL
{
    if (URL) {
        [_chainTaskURLs addObject:URL];
    }
}

- (void)send
{
    if (_state == URLSessionTaskStateWait)
    {
        _state = URLSessionChainTaskStateRunning;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        __block BOOL canContinue = YES;
        dispatch_group_async(group, queue, ^{
            for (int idx = 0; idx < self.chainTaskURLs.count; ++idx)
            {
                if (self.state == URLSessionChainTaskStateCancel) {
                    if (self.failure) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
                            self.failure(idx, error);
                        });
                    }
                    break;
                }
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                __weak typeof(self)weakSelf = self;
                URLSessionTask *task = [[URLSessionTask alloc] initWithURL:self.chainTaskURLs[idx] progress:^(double progress) {
                    if (weakSelf.progress) {
                        weakSelf.progress(idx, progress);
                    }
                } success:^(URLSessionTaskResponse *response) {
                    if (weakSelf.success) {
                        weakSelf.success(idx, response);
                    }
                    
                    if (!response.correct && idx < weakSelf.chainTaskURLs.count-1)
                    {
                        DEV_LOG(@"注意：第%d个请求成功，但是并不是正确的结果，这会停止余下的请求的发送。", idx);
                        canContinue = NO;
                        [weakSelf cancel];
                    }
                    
                    dispatch_semaphore_signal(sema);
                } failure:^(NSError *error) {
                    canContinue = NO;
                    if (weakSelf.failure) {
                        weakSelf.failure(idx, error);
                    }
                    [weakSelf cancel];
                    
                    dispatch_semaphore_signal(sema);
                }];
                
                if (!canContinue) {
                    break;
                }
                
                if (self.prepare) {
                    self.prepare(idx, task);
                }
                
                [task send];
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
        });
        
        dispatch_group_notify(group, queue, ^{
            self->_state = URLSessionChainTaskStateComplete;
            [[self chainQueue] removeObject:self];
        });
    }
}

- (void)cancel
{
    _state = URLSessionChainTaskStateCancel;
    [[self chainQueue] removeObject:self];
}

@end
