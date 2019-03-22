//
//  UIImage+CornerRadius.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

- (UIImage *)cropedImageWithCornerRaidus:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, cornerRadius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height-cornerRadius);
    CGContextAddArc(context, cornerRadius, self.size.height-cornerRadius, cornerRadius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width-cornerRadius, self.size.height);
    CGContextAddArc(context, self.size.width-cornerRadius, self.size.height-cornerRadius, cornerRadius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, cornerRadius);
    CGContextAddArc(context, self.size.width-cornerRadius, cornerRadius, cornerRadius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, cornerRadius, 0.0f);
    CGContextAddArc(context, cornerRadius, cornerRadius, cornerRadius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
