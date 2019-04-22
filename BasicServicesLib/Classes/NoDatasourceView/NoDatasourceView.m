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

#import "NoDatasourceView.h"
#import "Macros.h"
#import "UIView+CGRect.h"
#import "NSString+Size.h"

@interface NoDatasourceView ()

@property(copy, nonatomic) dispatch_block_t action;

@end

@implementation NoDatasourceView {
    __weak UIImageView *_imageView;
    __weak UILabel *_label;
    __weak UIButton *_retryButton;
}

+ (instancetype)showInView:(UIView *)aView
{
    if (aView == nil) {
        return nil;
    }
    
    NoDatasourceView *view = [[NoDatasourceView alloc] init];
    view.backgroundColor = UIColor.clearColor;
    view.frame = _CGRect(0, 0, aView.width, aView.height);
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelHeight = [_label.text boundingSizeWithFont:_label.font constrainedToSize:_CGSize(self.width - 30, 0)].height + 1;
    CGFloat totalHeight = _imageView.height + (_imageView == nil ? 0 : 10) + labelHeight + (_retryButton == nil ? 0 : 10) + _retryButton.height;
    CGFloat startY = self.height/2 - totalHeight/2;
    _imageView.center = _CGPoint(self.width/2, startY + _imageView.height/2);
    _label.frame = _CGRect(15, (_imageView == nil ? startY : (_imageView.bottom+10)), self.width - 30, labelHeight);
    _retryButton.frame = _CGRect(self.width/2-40, _label.bottom+10, 80, 35);
}

- (void)setImage:(UIImage *)image
{
    if (_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    _imageView.image = image;
    _imageView.bounds = (CGRect) { CGPointZero, image.size };
    [self layoutIfNeeded];
}

- (void)setMessage:(NSString *)message
{
    if (_label == nil)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.grayColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        [self addSubview:label];
        _label = label;
    }
    _label.text = message;
    [self layoutIfNeeded];
}

- (void)setRetryText:(NSString *)text
{
    if (_retryButton == nil)
    {
        UIButton *retryButton = [[UIButton alloc] init];
        [retryButton addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
        retryButton.height = 35;
        retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [retryButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        ViewBorderRadius(retryButton, 8, .5f, UIColor.grayColor);
        [self addSubview:retryButton];
        _retryButton = retryButton;
    }
    [_retryButton setTitle:text forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

- (void)setRetryAction:(dispatch_block_t)action
{
    _action = action;
}

- (void)retryAction:(UIButton *)sender
{
    if (_action) {
        _action();
    }
}

@end
