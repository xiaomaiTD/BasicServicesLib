//
//  View.m
//  BasicServicesLib
//
//  Created by yeeshe on 2019/3/27.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "View.h"

@implementation View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)setNeedsUpdateConstraints
{
    [super setNeedsUpdateConstraints];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)updateConstraints
{
    [super updateConstraints];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
    

@end
