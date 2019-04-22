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
