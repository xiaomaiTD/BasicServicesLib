//
//  UIRelayoutButton.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/13.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "UIRelayoutButton.h"
#import "Macros.h"
#import "UIView+CGRect.h"

@implementation UIRelayoutButton {
    UIRelayoutButtonStyle _style;
    CGFloat _spacing;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _setRelayoutButtonStyle:_style spacing:_spacing];
}

- (void)setRelayoutButtonStyle:(UIRelayoutButtonStyle)style spacing:(CGFloat)spacing
{
    _style = style;
    _spacing = spacing;
    [self layoutIfNeeded];
}

- (void)_setRelayoutButtonStyle:(UIRelayoutButtonStyle)style spacing:(CGFloat)spacing
{
    CGFloat imageWith = self.imageView.width;
    CGFloat imageHeight = self.imageView.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    }
    else
    {
        labelWidth = self.titleLabel.width;
        labelHeight = self.titleLabel.height;
    }
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;

    switch (style) {
        case UIRelayoutButtonStyleTop:
        {
            imageEdgeInsets = EDges(-labelHeight-spacing/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = EDges(0, -imageWith, -imageHeight-spacing/2.0, 0);
        }
            break;
        case UIRelayoutButtonStyleLeft:
        {
            imageEdgeInsets = EDges(0, -spacing/2.0, 0, spacing/2.0);
            labelEdgeInsets = EDges(0, spacing/2.0, 0, -spacing/2.0);
        }
            break;
        case UIRelayoutButtonStyleBottom:
        {
            imageEdgeInsets = EDges(0, 0, -labelHeight-spacing/2.0, -labelWidth);
            labelEdgeInsets = EDges(-imageHeight-spacing/2.0, -imageWith, 0, 0);
        }
            break;
        case UIRelayoutButtonStyleRight:
        {
            imageEdgeInsets = EDges(0, labelWidth+spacing/2.0, 0, -labelWidth-spacing/2.0);
            labelEdgeInsets = EDges(0, -imageWith-spacing/2.0, 0, imageWith+spacing/2.0);
        }
            break;
    }
    
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
