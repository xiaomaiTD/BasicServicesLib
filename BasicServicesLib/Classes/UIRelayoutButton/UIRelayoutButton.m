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
            imageEdgeInsets = _UIEdgeInsets(-labelHeight-spacing/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = _UIEdgeInsets(0, -imageWith, -imageHeight-spacing/2.0, 0);
        }
            break;
        case UIRelayoutButtonStyleLeft:
        {
            imageEdgeInsets = _UIEdgeInsets(0, -spacing/2.0, 0, spacing/2.0);
            labelEdgeInsets = _UIEdgeInsets(0, spacing/2.0, 0, -spacing/2.0);
        }
            break;
        case UIRelayoutButtonStyleBottom:
        {
            imageEdgeInsets = _UIEdgeInsets(0, 0, -labelHeight-spacing/2.0, -labelWidth);
            labelEdgeInsets = _UIEdgeInsets(-imageHeight-spacing/2.0, -imageWith, 0, 0);
        }
            break;
        case UIRelayoutButtonStyleRight:
        {
            imageEdgeInsets = _UIEdgeInsets(0, labelWidth+spacing/2.0, 0, -labelWidth-spacing/2.0);
            labelEdgeInsets = _UIEdgeInsets(0, -imageWith-spacing/2.0, 0, imageWith+spacing/2.0);
        }
            break;
    }
    
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
