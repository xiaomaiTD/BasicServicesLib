//
//  UIControl+SelectorBlocked.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
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
