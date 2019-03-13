//
//  UIView+CornerRadius.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct UICornerRadius {
    CGFloat t1, t2, b1, b2;
} UICornerRadius;

extern UICornerRadius UICornerRadiusMake(CGFloat t1, CGFloat t2, CGFloat b1, CGFloat b2);
extern BOOL UICornerRadiusEqual(UICornerRadius cr1, UICornerRadius cr2);

@interface UIView (CornerRadius)

/// 由于使用的是蒙版实现的，需要获取view的真实frame，应该在layoutSubviewss中调用
- (void)setCorners:(UICornerRadius)corners;
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
