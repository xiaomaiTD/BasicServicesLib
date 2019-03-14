//
//  UIImage+UIColor.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UIImage+UIColor.h"
#import "Macros.h"

@implementation UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)size
{
    CGRect rect = (CGRect) {CGPointZero, size};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)aColor
{
    return [self imageWithColor:aColor size:SIze(1.0, 1.0)];
}

@end
