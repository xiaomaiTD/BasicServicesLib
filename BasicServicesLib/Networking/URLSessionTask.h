//
//  Copyright © 2019 yeeshe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "URLSessionTaskParams.h"
#import "URLSessionTaskURL.h"
#import "URLSessionTaskResponse.h"

@protocol AFMultipartFormData;
@class URLSessionTask;

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

@protocol URLSessionTaskDelegate <NSObject>

@required

- (void)sessionTask:(URLSessionTask *)task requestDidSuccessThrowResponse:(URLSessionTaskResponse *)response;
- (void)sessionTask:(URLSessionTask *)task requestDidFailedThrowError:(NSError *)error;

@optional

- (void)sessionTask:(URLSessionTask *)task requestFinishedWithProgress:(double)progress;
- (void)sessionTask:(URLSessionTask *)task requestShouldConstructBody:(id<AFMultipartFormData>)formData;

@end

typedef void (^URLSessionTaskSuccessInterruptor) (URLSessionTaskResponse *response);

@interface URLSessionTask : NSObject

/// 通常网络请求成功会做一些通用配置，比如验证请求是否正确、登录失效等操作
/// 本方法用于设置这类通用配置。方法只会生效一次。
+ (void)setSuccessInerruptor:(URLSessionTaskSuccessInterruptor)interruptor;

/// 在HTTPS时自动使用。如果有path，则使用的是自签证书，抓包工具抓到的数据是经过证书加密的。
/// 本方法用于设置这类通用配置。方法只会生效一次。
+ (void)setHTTPSCerPath:(NSString *)path;

- (instancetype)initWithURL:(URLSessionTaskURL *)URL delegate:(id<URLSessionTaskDelegate> _Nonnull)delegate;

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

/// 当前的网络请求状态
- (URLSessionTaskState)state;
/// 发送网络请求
- (void)send;
/// 取消本次请求
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
