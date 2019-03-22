//
//  UIControl+SelectorBlocked.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/22.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

// Refer: https://www.jianshu.com/p/ee9756f3d5f6

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIControlResponder) (UIControl * _Nonnull sender);

@interface UIControl (SelectorBlocked)

/**
 * 由于block的原因，使用时需要注意循环引用，特别是使用self这种关键词。
 * 这个方法虽然使用起来方便，但是一定注意其内存管理，多使用weak。
 */
- (void)addBlockForControlEvents:(UIControlEvents)events responder:(UIControlResponder _Nonnull)responder;
- (void)removeBlocksForControlEvents:(UIControlEvents)events;

@end

NS_ASSUME_NONNULL_END
