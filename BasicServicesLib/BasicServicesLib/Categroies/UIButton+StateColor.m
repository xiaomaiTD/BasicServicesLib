//
//  UIButton+StateColor.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UIButton+StateColor.h"
#import "UIImage+UIColor.h"

@implementation UIButton (StateColor)

- (void)setBackgroundImageWithColors:(NSArray<UIColor*> *)colors
{
    [self setBackgroundImage:[UIImage imageWithColor:colors[0]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:colors[1]] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:colors[2]] forState:UIControlStateDisabled];
}

- (void)setTitleColorWithColors:(NSArray<UIColor*> *)colors
{
    [self setTitleColor:colors[0] forState:UIControlStateNormal];
    [self setTitleColor:colors[1] forState:UIControlStateHighlighted];
    [self setTitleColor:colors[2] forState:UIControlStateDisabled];
}

@end
