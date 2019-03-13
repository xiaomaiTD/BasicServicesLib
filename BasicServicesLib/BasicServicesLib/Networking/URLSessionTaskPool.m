//
//  URLSessionTaskPool.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionTaskPool.h"

@interface URLSessionTaskPool ()

@property(strong) NSMutableArray<URLSessionTask *> *tasks;

@end

@implementation URLSessionTaskPool

+ (instancetype)pool
{
    static dispatch_once_t onceToken;
    static URLSessionTaskPool *pool = nil;
    dispatch_once(&onceToken, ^{
        pool = [[URLSessionTaskPool alloc] init];
    });
    return pool;
}

- (instancetype)init
{
    if (self = [super init]) {
        _tasks = NSMutableArray.array;
    }
    return self;
}

- (URLSeesionTasks)sessionTasks
{
    return [_tasks copy];
}

- (URLSeesionTasks)runningTasks
{
    NSMutableArray *runnings = NSMutableArray.array;
    
    for (int idx = 0; idx < _tasks.count; ++ idx)
    {
        if ([_tasks[idx] state] == URLSessionTaskStateRunning) {
            [runnings addObject:_tasks[idx]];
        }
    }
    
    return runnings.count == 0 ? nil : [runnings copy];
}

- (void)addTask:(URLSessionTask *)task
{
    if (task == nil) {
        return;
    }
    
    [_tasks addObject:task];
}

- (void)removeTask:(URLSessionTask *)task
{
    if (task == nil) {
        return;
    }
    
    [_tasks removeObject:task];
}

@end
