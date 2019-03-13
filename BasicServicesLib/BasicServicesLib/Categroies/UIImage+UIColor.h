//
//  UIImage+UIColor.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UIColor)

+ (nullable UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)size;
+ (nullable UIImage *)imageWithColor:(UIColor *)aColor;

@end

NS_ASSUME_NONNULL_END
