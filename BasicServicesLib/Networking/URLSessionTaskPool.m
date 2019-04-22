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
