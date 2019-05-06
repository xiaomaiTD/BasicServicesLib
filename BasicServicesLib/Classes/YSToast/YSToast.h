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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YSToastStyle) {
    YSToastStyleIndicator,
    YSToastStyleToast
};

typedef NS_ENUM(NSInteger, YSToastPosition) {
    YSToastPositionCenter,
    YSToastPositionBottom
};

@interface YSToast : UIView

- (instancetype)init;

@property(assign, nonatomic, readonly) YSToastStyle style;

@property(assign, nonatomic) YSToastPosition position;

/// The color of mask.
@property(strong, nonatomic) UIColor *color;

/// The toast content view background color.
@property(strong, nonatomic) UIColor *contentColor;

/// The toast insets margin.
@property(assign, nonatomic) CGFloat margin;

/// The corner radius of toast's content view.
@property(assign, nonatomic) CGFloat contentCornerRadius;

/// Can user action accross the toast background view. If YES , the background view is the same size of toast content.
@property(assign, nonatomic, getter=isEnableAccrossInteraction) BOOL enableAccrossInteraction;

@property(weak, nonatomic, readonly) UILabel *label;

- (void)setupSubviews;
- (void)layoutSubviewsWithFrame:(CGRect)frame;
- (CGSize)contentSize;

@end

@interface YSToastOnlyText : YSToast

- (void)setEnableAccrossInteraction:(BOOL)enableAccrossInteraction __attribute__((unavailable));

@end

@interface YSToastIndicator : YSToast

@property(strong, nonatomic) UIColor *indicatorColor;

@end

@interface UIView (Toast)

- (void)makeToast:(NSString * _Nonnull)text;
- (void)makeToast:(NSString * _Nonnull)text afterDelay:(NSTimeInterval)delay;
- (void)makeToast:(NSString * _Nonnull)text position:(YSToastPosition)position afterDelay:(NSTimeInterval)delay;

@end

@interface UIView (Indicator)

- (void)makeIndicator:(NSString * _Nonnull)text;
- (void)makeIndicator:(NSString * _Nonnull)text enableAccrossInteraction:(BOOL)yesOrNo;

- (void)makeIndicatorSuccess:(NSString * _Nonnull)reason;
- (void)makeIndicatorSuccess:(NSString * _Nonnull)reason afterDelay:(NSTimeInterval)delay;
- (void)makeIndicatorFailsure:(NSString * _Nonnull)reason;
- (void)makeIndicatorFailsure:(NSString * _Nonnull)reason afterDelay:(NSTimeInterval)delay;
- (void)hideIndicator;

@end

NS_ASSUME_NONNULL_END
