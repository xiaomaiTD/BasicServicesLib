//
//  MBProgressHUDUtil.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ToastPosition) {
    ToastPositionCenter,
    ToastPositionBottom
};

@interface MBProgressHUDUtil : NSObject

+ (void)ToastWithText:(nonnull NSString *)text inView:(nullable UIView *)aView atPosition:(ToastPosition)position dismissAfter:(CGFloat)delay;
+ (void)ToastWithText:(nonnull NSString *)text inView:(nullable UIView *)aView;

/// enable = YES 表示可以透过hud点击下层视图而得到响应。
+ (void)LoadingWithText:(nullable NSString *)text inView:(nullable UIView *)aView contentBackgroundColor:(nullable UIColor *)color maskBackground:(BOOL)mask userInteraction:(BOOL)enable;
/// enable = NO
+ (void)LoadingWithText:(nullable NSString *)text inView:(nullable UIView *)aView contentBackgroundColor:(nullable UIColor *)color maskBackground:(BOOL)mask;
+ (void)LoadingWithText:(nullable NSString *)text inView:(nullable UIView *)aView;

+ (void)SuccessWithText:(nullable NSString *)text inView:(nullable UIView *)aView contentBackgroundColor:(nullable UIColor *)color maskBackground:(BOOL)mask;
+ (void)SuccessWithText:(nullable NSString *)text inView:(nullable UIView *)aView;

+ (void)ErrorWithText:(nullable NSString *)text inView:(nullable UIView *)aView contentBackgroundColor:(nullable UIColor *)color maskBackground:(BOOL)mask;
+ (void)ErrorWithText:(nullable NSString *)text inView:(nullable UIView *)aView;

@end

NS_ASSUME_NONNULL_END
