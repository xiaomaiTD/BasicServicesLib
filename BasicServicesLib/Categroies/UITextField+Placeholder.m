//
//  UITextField+Placeholder.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UITextField+Placeholder.h"

NSString * const kTextFieldPlaceholderKeypathColorName = @"_placeholderLabel.textColor";
NSString * const kTextFieldPlaceholderKeypathFontName = @"_placeholderLabel.font";

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)aColor
{
    [self setValue:aColor forKeyPath:kTextFieldPlaceholderKeypathColorName];
}

- (void)setPlaceholderFont:(UIFont *)aFont
{
    [self setValue:aFont forKeyPath:kTextFieldPlaceholderKeypathFontName];
}

@end
