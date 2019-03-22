//
//  NSNotificationCenter+ObserverBlocked.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "NSNotificationCenter+ObserverBlocked.h"
#import <objc/runtime.h>

@interface NSNotificationCenterBlockTarget : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier block:(NSNotificationCenterResponder)block;
@property(strong, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSNotificationCenterResponder block;

- (void)respondToNotification:(NSNotification *)aNotice;

@end

@implementation NSNotificationCenterBlockTarget

- (instancetype)initWithIdentifier:(NSString *)identifier block:(NSNotificationCenterResponder)block
{
    if (self = [super init])
    {
        self.identifier = identifier;
        self.block = block;
    }
    return self;
}

- (void)respondToNotification:(NSNotification *)aNotice
{
    if (self.block) {
        self.block(aNotice);
    }
}

@end

@implementation NSNotificationCenter (ObserverBlocked)

static const char * kNotificationBlockedTargetsAssociateKey = "\0";

- (void)addBlockWithName:(NSNotificationName)aName object:(id)anObject identifier:(NSString *)identifier responder:(NSNotificationCenterResponder)responder
{
    if (!aName || !identifier || !responder) {
        return;
    }
    
    NSNotificationCenterBlockTarget *target = [[NSNotificationCenterBlockTarget alloc] initWithIdentifier:identifier block:responder];
    NSMutableDictionary *dic = [self getBlockedTargetsMap];
    NSMutableArray *arr = dic[aName];
    if (!arr)
    {
        arr = [NSMutableArray arrayWithCapacity:0];
        [dic setValue:arr forKey:aName];
    }
    [arr addObject:target];
    [self addObserver:target selector:@selector(respondToNotification:) name:aName object:anObject];
}

- (void)removeBlockWithName:(NSNotificationName)aName identifier:(NSString *)identifier
{
    NSMutableDictionary *dic = [self getBlockedTargetsMap];
    NSMutableArray *arr = dic[aName];
    if (arr)
    {
        __block NSNotificationCenterBlockTarget *target = nil;
        [arr enumerateObjectsUsingBlock:^(NSNotificationCenterBlockTarget *_target, NSUInteger idx, BOOL * stop) {
            if ([_target.identifier isEqualToString:identifier])
            {
                target = _target;
                [self removeObserver:target];
                *stop = YES;
            }
        }];
        [arr removeObject:target];
    }
}

- (NSMutableDictionary *)getBlockedTargetsMap
{
    NSMutableDictionary *map = objc_getAssociatedObject(self, kNotificationBlockedTargetsAssociateKey);
    if (!map)
    {
        map = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, kNotificationBlockedTargetsAssociateKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return map;
}

@end
