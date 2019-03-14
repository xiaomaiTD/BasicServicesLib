//
//  UIView+CornerRadius.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>
#import "Macros.h"

UICornerRadius UICornerRadiusMake(CGFloat t1, CGFloat t2, CGFloat b1, CGFloat b2)
{
    UICornerRadius cornerRadii;
    cornerRadii.t1 = t1; cornerRadii.t2 = t2; cornerRadii.b1 = b1; cornerRadii.b2 = b2;
    return cornerRadii;
}

BOOL UICornerRadiusEqual(UICornerRadius cr1, UICornerRadius cr2)
{
    return cr1.t1 == cr2.t1 && cr1.t2 == cr2.t2 && cr1.b1 == cr2.b1 && cr1.b2 == cr2.b2;
}

static CGPathRef path_from(CGRect rect, UICornerRadius corners)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, corners.t1, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width-corners.t2, 0);
    CGPathAddArc(path, NULL, rect.size.width-corners.t2, corners.t2, corners.t2, M_PI*1.5, M_PI*2, NO);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height-corners.b2);
    CGPathAddArc(path, NULL, rect.size.width-corners.b2, rect.size.height-corners.b2, corners.b2, 0, M_PI*0.5, NO);
    CGPathAddLineToPoint(path, NULL, corners.b1, rect.size.height);
    CGPathAddArc(path, NULL, corners.b1, rect.size.height-corners.b1, corners.b1, M_PI*0.5, M_PI, NO);
    CGPathAddLineToPoint(path, NULL, 0, corners.t1);
    CGPathAddArc(path, NULL, corners.t1, corners.t1, corners.t1, M_PI, M_PI*1.5, NO);
    CGPathCloseSubpath(path);
    return path;
}

@implementation UIView (CornerRadius)

static char * const kUIViewCornersAssociateKey = "\0";

- (void)setCorners:(UICornerRadius)corners
{
    NSValue *cornersValue = objc_getAssociatedObject(self, kUIViewCornersAssociateKey);
    UICornerRadius _corners;
    if (cornersValue == nil) {
        _corners = UICornerRadiusMake(0, 0, 0, 0);
    }
    else
    {
        [cornersValue getValue:&_corners];
    }
    
    if (!UICornerRadiusEqual(_corners, corners))
    {
        NSValue *object = [NSValue value:&corners withObjCType:@encode(UICornerRadius)];
        objc_setAssociatedObject(self, kUIViewCornersAssociateKey, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        CGPathRef path = path_from(self.bounds, corners);
        maskLayer.path = path;
        self.layer.mask = maskLayer;
        CGPathRelease(path);
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [self setCorners:UICornerRadiusMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

@end
