//
//  NSNotificationCenter+ObserverBlocked.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NSNotificationCenterResponder) (id sender);

@interface NSNotificationCenter (ObserverBlocked)

/**
 * 由于通知中心是一个单利对象，如果采用和KVO相同的思路实现block替换的话会造成移除block时将不需要移除的也一并移除掉。
 * 目前的解决办法是给该block添加一个唯一键值(identifier)。
 * block使用时，请注意循环引用。
 * 其他办法呢？
 */
- (void)addBlockWithName:(NSNotificationName _Nonnull)aName object:(id _Nullable)anObject identifier:(NSString * _Nonnull)identifier responder:(NSNotificationCenterResponder _Nonnull)responder;

/**
 * 添加后一定要在delloc中移除。
 */
- (void)removeBlockWithName:(NSNotificationName _Nonnull)aName identifier:(NSString * _Nonnull)identifier;

@end

NS_ASSUME_NONNULL_END
