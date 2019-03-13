//
//  URLSessionChainTask.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/12.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLSessionTask.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, URLSessionChainTaskState) {
    URLSessionChainTaskStateWait,
    URLSessionChainTaskStateRunning,
    URLSessionChainTaskStateCancel,
    URLSessionChainTaskStateComplete
};

/// 注意：准备block的调用线程不是主线程
typedef void (^URLSessionChainTaskPrepare) (NSInteger index, URLSessionTask *task);
typedef void (^URLSessionChainTaskProgress) (NSInteger index, double progress);
typedef void (^URLSessionChainTaskSuccess) (NSInteger index, URLSessionTaskResponse *response);
typedef void (^URLSessionChainTaskFailure) (NSInteger index, NSError *error);

@interface URLSessionChainTask : NSObject

- (instancetype)initWithPrepare:(URLSessionChainTaskPrepare _Nonnull)prepare progress:(URLSessionChainTaskProgress _Nullable)progress success:(URLSessionChainTaskSuccess _Nonnull)success failure:(URLSessionChainTaskFailure _Nonnull)failure;

@property(assign, readonly) URLSessionChainTaskState state;

- (void)addTaskURL:(URLSessionTaskURL * _Nonnull)URL;
- (void)send;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
