//
//  URLSessionTaskPool.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLSessionTask.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSArray<URLSessionTask *> * URLSeesionTasks;

@interface URLSessionTaskPool : NSObject

+ (instancetype)pool;

- (URLSeesionTasks)sessionTasks;
- (URLSeesionTasks)runningTasks;

- (void)addTask:(URLSessionTask *)task;
- (void)removeTask:(URLSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
