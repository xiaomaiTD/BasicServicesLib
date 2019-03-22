//
// NSObject+KVOBlocked.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "NSObject+KVOBlocked.h"
#import <objc/runtime.h>

typedef void (^NSObjectWeakifyKVOResponder) (__weak id obj, id oldValue, id newValue);

@interface NSObjectBlockedTarget : NSObject

- (instancetype)initWithBlock:(NSObjectWeakifyKVOResponder)block;
@property(copy, nonatomic) NSObjectWeakifyKVOResponder block;

@end

@implementation NSObjectBlockedTarget

- (instancetype)initWithBlock:(NSObjectWeakifyKVOResponder)block
{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

// Refer-1: https://juejin.im/post/5c22023df265da6124157a25
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.block) {
        return;
    }
    
    // Refer-2: https://www.jianshu.com/p/d104daf7a062
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) {
        return;
    }
    
    // Refer-3: http://liumh.com/2015/08/25/ios-know-kvo/
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (newValue == [NSNull null]) {
        newValue = nil;
    }
    
    __weak __typeof__(object) weakObject = object;
    self.block(weakObject, oldValue, newValue);
}

@end

@implementation NSObject (KVOBlocked)

static const char * kKVOBlockedResponderMapAssociateKey = "\0";

- (void)addObserverBlockedForKeyPath:(NSString *)keyPath responder:(NSObjectKVOResponder)responder
{
    if (!keyPath || !responder) {
        return;
    }
    
    NSObjectBlockedTarget *target = [[NSObjectBlockedTarget alloc] initWithBlock:responder];
    NSMutableDictionary *responderMap = [self getKVOBlockedResponderMap];
    NSMutableArray *arr = responderMap[keyPath];
    if (!arr)
    {
        arr = [NSMutableArray arrayWithCapacity:0];
        [responderMap setValue:arr forKey:keyPath];
    }
    [arr addObject:target];
    
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverBlockedForKeyPath:(NSString *)keyPath
{
    if (!keyPath) {
        return;
    }
    
    NSMutableDictionary *responderMap = [self getKVOBlockedResponderMap];
    NSMutableArray *arr = responderMap[keyPath];
    if (arr)
    {
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:keyPath];
        }];
    }
    [responderMap removeObjectForKey:keyPath];
}

- (void)removeAllObserverBlocks
{
    NSMutableDictionary *responderMap = [self getKVOBlockedResponderMap];
    [responderMap enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, NSMutableArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:keyPath];
        }];
    }];
    [responderMap removeAllObjects];
}

- (NSMutableDictionary *)getKVOBlockedResponderMap
{
    NSMutableDictionary *map = objc_getAssociatedObject(self, kKVOBlockedResponderMapAssociateKey);
    if (!map)
    {
        map = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, kKVOBlockedResponderMapAssociateKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return map;
}

@end
