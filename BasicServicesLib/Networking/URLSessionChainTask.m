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

#import "URLSessionChainTask.h"
#import "Macros.h"

@interface URLSessionChainTask () <URLSessionTaskDelegate> {
    struct {
        unsigned prepareParams: 1;
        unsigned requestDidSuccessThrowResponse: 1;
        unsigned requestDidFailedThrowError: 1;
        unsigned requestFinishedWithProgress: 1;
        unsigned requestShouldConstructBody: 1;
    } _delegateHas;
}

@property(strong, nonatomic) NSMutableArray<URLSessionTaskURL*> *chainTaskURLs;
@property(weak, nonatomic) id<URLSessionChainTaskDelegate> delegate;
@property(assign, nonatomic) __block NSInteger index;
@property(assign, nonatomic) __block BOOL canContinue;
@property(strong, nonatomic) dispatch_semaphore_t sema;

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

- (instancetype)initWithDelegate:(id<URLSessionChainTaskDelegate>)delegate
{
    if (delegate == nil) {
        return nil;
    }
    
    if (self = [super init])
    {
        _state = URLSessionChainTaskStateWait;
        _chainTaskURLs = [NSMutableArray array];
        _canContinue = YES;
        [self setDelegate:delegate];
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
        _sema = dispatch_semaphore_create(0);

        @weakify(self)
        dispatch_group_async(group, queue, ^{
            @strongify(self)
            for (int idx = 0; idx < self.chainTaskURLs.count; ++idx)
            {
                self.index = idx;
                
                if (!self.canContinue) {
                    break;
                }
                
                if (self.state == URLSessionChainTaskStateCancel) {
                    if (self->_delegateHas.requestDidFailedThrowError) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
                            [self.delegate sessionChainTask:self requestDidFailedThrowError:error atIndex:self.index];
                        });
                    }
                    break;
                }
                
                URLSessionTask *task = [[URLSessionTask alloc] initWithURL:self.chainTaskURLs[idx] delegate:self];
                
                if (self->_delegateHas.prepareParams) {
                    [self.delegate sessionChainTask:self prepareParamsFor:task atIndex:idx];
                }
                
                [task send];
                dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
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

#pragma mark - Setter

- (void)setDelegate:(id<URLSessionChainTaskDelegate>)newDelegate
{
    _delegate = newDelegate;
    
    _delegateHas.prepareParams = [newDelegate respondsToSelector:@selector(sessionChainTask:prepareParamsFor:atIndex:)];
    _delegateHas.requestDidSuccessThrowResponse = [newDelegate respondsToSelector:@selector(sessionChainTask:requestDidSuccessThrowResponse:atIndex:)];
    _delegateHas.requestDidFailedThrowError = [newDelegate respondsToSelector:@selector(sessionChainTask:requestDidFailedThrowError:atIndex:)];
    _delegateHas.requestFinishedWithProgress = [newDelegate respondsToSelector:@selector(sessionChainTask:requestFinishedWithProgress:atIndex:)];
    _delegateHas.requestShouldConstructBody = [newDelegate respondsToSelector:@selector(sessionChainTask:requestShouldConstructBody:atIndex:)];
}

#pragma mark - <URLSessionTaskDelegate>

- (void)sessionTask:(URLSessionTask *)task requestFinishedWithProgress:(double)progress
{
    if (_delegateHas.requestFinishedWithProgress) {
        [self.delegate sessionChainTask:self requestFinishedWithProgress:progress atIndex:self.index];
    }
}

- (void)sessionTask:(URLSessionTask *)task requestShouldConstructBody:(id<AFMultipartFormData>)formData
{
    if (_delegateHas.requestShouldConstructBody) {
        [self.delegate sessionChainTask:self requestShouldConstructBody:formData atIndex:self.index];
    }
}

- (void)sessionTask:(URLSessionTask *)task requestDidFailedThrowError:(NSError *)error
{
    self.canContinue = NO;
    
    if (_delegateHas.requestDidFailedThrowError) {
        [self.delegate sessionChainTask:self requestDidFailedThrowError:error atIndex:self.index];
    }
    
    [self cancel];
    dispatch_semaphore_signal(_sema);
}

- (void)sessionTask:(URLSessionTask *)task requestDidSuccessThrowResponse:(URLSessionTaskResponse *)response
{
    if (_delegateHas.requestDidSuccessThrowResponse) {
        [self.delegate sessionChainTask:self requestDidSuccessThrowResponse:response atIndex:self.index];
    }
    
    if (!response.correct && self.index < self.chainTaskURLs.count-1)
    {
        DEV_LOG(@"注意：第%ld个请求成功，但是并不是正确的结果，这会停止余下的请求的发送。", (long)self.index);
        self.canContinue = NO;
        [self cancel];
    }
    
    dispatch_semaphore_signal(_sema);
}

@end
