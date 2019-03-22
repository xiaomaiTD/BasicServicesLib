//
//  NSObject+KVOBlocked.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NSObjectKVOResponder) (id _Nonnull object, id _Nullable oldValue, id _Nullable newValue);

@interface NSObject (KVOBlocked)

/**
 * block使用时，请注意循环引用。
 */
- (void)addObserverBlockedForKeyPath:(NSString * _Nonnull)keyPath responder:(NSObjectKVOResponder)responder;
- (void)removeObserverBlockedForKeyPath:(NSString * _Nonnull)keyPath;
- (void)removeAllObserverBlocks;

@end

NS_ASSUME_NONNULL_END
