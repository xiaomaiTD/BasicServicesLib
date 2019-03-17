//
//  URLSessionChainTask.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/12.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLSessionTask.h"

@class URLSessionChainTask;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, URLSessionChainTaskState) {
    URLSessionChainTaskStateWait,
    URLSessionChainTaskStateRunning,
    URLSessionChainTaskStateCancel,
    URLSessionChainTaskStateComplete
};

@protocol URLSessionChainTaskDelegate <NSObject>

@required

- (void)sessionChainTask:(URLSessionChainTask *)chainTask prepareParamsFor:(URLSessionTask *)task atIndex:(NSInteger)index;
- (void)sessionChainTask:(URLSessionChainTask *)task requestDidSuccessThrowResponse:(URLSessionTaskResponse *)response atIndex:(NSInteger)index;
- (void)sessionChainTask:(URLSessionChainTask *)task requestDidFailedThrowError:(NSError *)error atIndex:(NSInteger)index;

@optional

- (void)sessionChainTask:(URLSessionChainTask *)task requestFinishedWithProgress:(double)progress atIndex:(NSInteger)index;
- (void)sessionChainTask:(URLSessionChainTask *)task requestShouldConstructBody:(id<AFMultipartFormData>)formData atIndex:(NSInteger)index;

@end

@interface URLSessionChainTask : NSObject

- (instancetype)initWithDelegate:(id<URLSessionChainTaskDelegate> _Nonnull)delegate;

@property(assign, readonly) URLSessionChainTaskState state;

- (void)addTaskURL:(URLSessionTaskURL * _Nonnull)URL;
- (void)send;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
