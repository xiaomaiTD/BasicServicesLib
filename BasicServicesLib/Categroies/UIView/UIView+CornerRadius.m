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

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>
#import "Macros.h"

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
