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

#import <UIKit/UIKit.h>

/**
 * 由于MBProgressHUD在添加到UIScrollView后，会导致bezelView并不是在最中间，所以尽量不将其添加到滚动式图上。
 */

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
