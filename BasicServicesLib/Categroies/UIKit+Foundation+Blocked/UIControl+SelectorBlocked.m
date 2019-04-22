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

#import "UIControl+SelectorBlocked.h"
#import <objc/runtime.h>

typedef void (^UIControlWeakifyResponder) (__weak UIControl *sender);

@interface UIControlBlockedTarget : NSObject

- (instancetype)initWithEvents:(UIControlEvents)events block:(UIControlWeakifyResponder)block;
@property(assign, nonatomic) UIControlEvents events;
@property(copy, nonatomic) UIControlWeakifyResponder block;

- (void)respondControlWithSender:(UIControl *)sender;

@end

@implementation UIControlBlockedTarget

- (instancetype)initWithEvents:(UIControlEvents)events block:(UIControlWeakifyResponder)block
{
    if (self = [super init]) {
        self.events = events;
        self.block = block;
    }
    return self;
}

- (void)respondControlWithSender:(UIControl *)sender
{
    if (self.block)
    {
        __weak __typeof__(sender) weakSender = sender;
        self.block(weakSender);
    }
}

@end

@implementation UIControl (SelectorBlocked)

static const char * kBlockedEventsTargetsAssociateKey = "\0";

- (void)addBlockForControlEvents:(UIControlEvents)events responder:(UIControlResponder)responder
{
    if (!events || !responder) {
        return;
    }
    
    // 由于UIControl的allTargets并不是强持有所有的target，所以必须声明一个数组来持有它。
    UIControlBlockedTarget *target = [[UIControlBlockedTarget alloc] initWithEvents:events block:responder];
    [self addTarget:target action:@selector(respondControlWithSender:) forControlEvents:events];
    [[self getBlockedTargets] addObject:target];
}

- (void)removeBlocksForControlEvents:(UIControlEvents)events
{
    if (!events) {
        return;
    }
    
    NSArray *target = [self getBlockedTargets];
    [target enumerateObjectsUsingBlock:^(UIControlBlockedTarget *target, NSUInteger idx, BOOL *stop) {
        if (target.events == events) {
            [self removeTarget:target action:@selector(respondControlWithSender:) forControlEvents:events];
        }
    }];
}

- (NSMutableArray<UIControlBlockedTarget*> *)getBlockedTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, kBlockedEventsTargetsAssociateKey);
    if (!targets)
    {
        targets = [NSMutableArray arrayWithCapacity:0];
        objc_setAssociatedObject(self, kBlockedEventsTargetsAssociateKey, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
