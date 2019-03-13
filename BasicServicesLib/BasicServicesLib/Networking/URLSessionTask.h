//
//  URLSessionTask.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLSessionTaskParams.h"
#import "URLSessionTaskURL.h"
#import "URLSessionTaskResponse.h"

@protocol AFMultipartFormData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, URLSessionTaskState) {
    URLSessionTaskStateWait,
    URLSessionTaskStateReady,
    URLSessionTaskStateRunning,
    URLSessionTaskStateCancel,
    URLSessionTaskStateCompleted
};

typedef NS_ENUM(NSInteger, URLSessionTaskMethod) {
    URLSessionTaskMethodPOST,
    URLSessionTaskMethodGET,
    URLSessionTaskMethodPUT,
    URLSessionTaskMethodPATCH,
    URLSessionTaskMethodHEAD,
    URLSessionTaskMethodDELETE,
    // 在AFN中的 AFMultipartFormData
    URLSessionTaskMethodMULTIPART_FORM
};

typedef void (^URLSessionTaskMultipartFormData) (id<AFMultipartFormData> formData);
typedef void (^URLSessionTaskProgress) (double progress);
typedef void (^URLSessionTaskSuccess) (URLSessionTaskResponse *response);
typedef void (^URLSessionTaskFailure) (NSError *error);
typedef URLSessionTaskSuccess URLSessionTaskSuccessInterruptor;

@interface URLSessionTask : NSObject

/// 通常网络请求成功会做一些通用配置，比如验证请求是否正确、登录失效等操作
/// 本方法用于设置这类通用配置。方法只会生效一次。
+ (void)setSuccessInerruptor:(URLSessionTaskSuccessInterruptor)interruptor;

/// 在HTTPS时自动使用。如果有path，则使用的是自签证书，抓包工具抓到的数据是经过证书加密的。
/// 本方法用于设置这类通用配置。方法只会生效一次。
+ (void)setHTTPSCerPath:(NSString *)path;

- (instancetype)initWithURL:(URLSessionTaskURL *)URL progress:(nullable URLSessionTaskProgress)progress success:(URLSessionTaskSuccess)success failure:(URLSessionTaskFailure)failure;

/// 请求链接
@property(strong, nonatomic, readonly) URLSessionTaskURL *URL;
/// 请求参数
@property(strong) URLSessionTaskParams *params;
/// 请求方式，默认POST
@property(assign) URLSessionTaskMethod method;
/// 请求超时时限，默认为30s
@property(assign) NSTimeInterval timeout;
/// 用于模型化请求结果的类
@property(assign) Class transferCls;
/// formData
@property(copy) URLSessionTaskMultipartFormData formData;

/// 当前的网络请求状态
- (URLSessionTaskState)state;
/// 发送网络请求
- (void)send;
/// 取消本次请求
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
