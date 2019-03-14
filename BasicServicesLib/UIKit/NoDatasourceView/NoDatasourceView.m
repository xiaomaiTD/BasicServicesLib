//
//  NoDatasourceView.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/4.
//  Copyright © 2019 Luckeyhill. All rights reserved.
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
    view.frame = REct(0, 0, aView.width, aView.height);
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelHeight = [_label.text boundingSizeWithFont:_label.font constrainedToSize:SIze(self.width - 30, 0)].height + 1;
    CGFloat totalHeight = _imageView.height + (_imageView == nil ? 0 : 10) + labelHeight + (_retryButton == nil ? 0 : 10) + _retryButton.height;
    CGFloat startY = self.height/2 - totalHeight/2;
    _imageView.center = POint(self.width/2, startY + _imageView.height/2);
    _label.frame = REct(15, (_imageView == nil ? startY : (_imageView.bottom+10)), self.width - 30, labelHeight);
    _retryButton.frame = REct(self.width/2-40, _label.bottom+10, 80, 35);
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
