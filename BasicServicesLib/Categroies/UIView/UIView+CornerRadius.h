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

typedef struct UICornerRadius {
    CGFloat t1, t2, b1, b2;
} UICornerRadius;

NS_INLINE UICornerRadius UICornerRadiusMake(CGFloat t1, CGFloat t2, CGFloat b1, CGFloat b2)
{
    UICornerRadius cornerRadii;
    cornerRadii.t1 = t1; cornerRadii.t2 = t2; cornerRadii.b1 = b1; cornerRadii.b2 = b2;
    return cornerRadii;
};

NS_INLINE BOOL UICornerRadiusEqual(UICornerRadius cr1, UICornerRadius cr2)
{
    return cr1.t1 == cr2.t1 && cr1.t2 == cr2.t2 && cr1.b1 == cr2.b1 && cr1.b2 == cr2.b2;
}

@interface UIView (CornerRadius)

/// 由于使用的是蒙版实现的，需要获取view的真实frame，应该在layoutSubviewss中调用
- (void)setCorners:(UICornerRadius)corners;
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
