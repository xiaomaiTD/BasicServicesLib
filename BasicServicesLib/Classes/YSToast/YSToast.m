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

#import "YSToast.h"
#import "Macros.h"
#import "NSBundle+BasicServicesLibResource.h"
#import "NSObject+KVOBlocked.h"
#import "NSString+Size.h"
#import "UIView+CGRect.h"
#import "YSChainAnimator.h"

#define INDICATOR_OR_IMAGE_SIZE  _CGSize(20, 20)
#define SPACING_WHEN_INDICATOR   (8.f)
#define POSITION_BOTTOM_SAPCING  (30.f)
#define YSTOAST_SHOW_DURATION    (0.087f)

@interface NSBundle (YSToast)

+ (UIImage *)imageWithSuccess:(BOOL)yesOrNo;

@end

@implementation NSBundle (YSToast)

+ (UIImage *)imageWithSuccess:(BOOL)yesOrNo
{
    if (yesOrNo)
    {
        static UIImage *imageSuccess = nil;
        if (imageSuccess == nil)
        {
            NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"toast-indicator-success@3x":@"toast-indicator-success@2x");
            NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
            imageSuccess = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        return imageSuccess;
    }
    else
    {
        static UIImage *imageError = nil;
        if (imageError == nil)
        {
            NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"toast-indicator-error@3x":@"toast-indicator-error@2x");
            NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
            imageError = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        return imageError;
    }
}

@end


@interface YSToast () {
    NSTimer *_hideTimer;
}

@property(weak, nonatomic) UIView *contentView;
@property(weak, nonatomic) UILabel *label;
@property(assign, nonatomic) CGSize contentSize;
@property(assign, nonatomic) YSToastStyle style;

@end

@implementation YSToast

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    _contentColor = ColorRGBA(0, 0, 0, 0.87);
    _color = ColorRGBA(0, 0, 0, 0.43);
    _margin = 8.f;
    _contentCornerRadius = 3.f;
    _enableAccrossInteraction = true;
    _style = YSToastStyleToast;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = _contentColor;
    contentView.clipsToBounds = true;
    ViewBorderRadius(contentView, _contentCornerRadius, 0, nil);
    ViewShadow(contentView, _contentColor, 0.2, 3, CGSizeZero);
    [self addSubview:contentView];
    _contentView = contentView;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 3;
    label.font = FontOfSize(13);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    _label = label;
    
    @weakify(self)
    [self.label addObserverBlockedForKeyPath:@"text" responder:^(id object, id oldValue, id newValue) {
        @strongify(self)
        [self updateSelfFrameIfNeeded];
    }];
    
    [self.label addObserverBlockedForKeyPath:@"font" responder:^(id object, id oldValue, id newValue) {
        @strongify(self)
        [self updateSelfFrameIfNeeded];
    }];
    
    [self addObserverBlockedForKeyPath:@"margin" responder:^(id object, id oldValue, id newValue) {
        @strongify(self)
        [self updateSelfFrameIfNeeded];
    }];
    
    [self addObserverBlockedForKeyPath:@"position" responder:^(id object, id oldValue, id newValue) {
        @strongify(self)
        [self updateSelfFrameIfNeeded];
    }];
}

- (void)layoutSubviewsWithFrame:(CGRect)frame
{
    NSAssert(true, @"YSToast should define method 'addViewsConstraints' by sub classes.");
}

- (void)updateSelfFrameIfNeeded
{
    CGSize textSize = CGSizeZero;
    if (self.style == YSToastStyleToast) {
        textSize = [self.label.text boundingSizeWithFont:self.label.font constrainedToSize:_CGSize(self.superview.width-2*self.margin-40, 0)];
    }
    else
    {
        textSize = [self.label.text boundingSizeWithFont:self.label.font constrainedToSize:_CGSize(self.superview.width-2*self.margin-40-INDICATOR_OR_IMAGE_SIZE.width-SPACING_WHEN_INDICATOR, self.label.font.lineHeight)];
        textSize = _CGSize(textSize.width+INDICATOR_OR_IMAGE_SIZE.width+SPACING_WHEN_INDICATOR, MAX(textSize.height, INDICATOR_OR_IMAGE_SIZE.height));
    }
    
    CGRect frame = CGRectZero;
    if (self.enableAccrossInteraction) {
        frame = _CGRect(0, 0, textSize.width+self.margin*2, textSize.height+self.margin*2);
    }
    else
    {
        frame = self.superview.bounds;
    }
    
    if (self.position == YSToastPositionCenter) {
        frame.origin = _CGPoint(self.superview.width/2-frame.size.width/2, self.superview.height/2-frame.size.height/2);
    }
    else
    {
        frame.origin = _CGPoint(self.superview.width/2-frame.size.width/2, self.superview.height-POSITION_BOTTOM_SAPCING-frame.size.height);
    }
    
    if (!CGRectEqualToRect(self.frame, frame) || !CGSizeEqualToSize(textSize, self.contentSize))
    {
        self.contentSize = _CGSize(textSize.width+2*self.margin, textSize.height+2*self.margin);
        self.frame = frame;
    }
}

- (void)invalidateTimer
{
    if (_hideTimer)
    {
        [_hideTimer invalidate];
        _hideTimer = nil;
    }
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
    if (_hideTimer != nil) {
        [self invalidateTimer];
    }
    
    _hideTimer = [NSTimer timerWithTimeInterval:delay+YSTOAST_SHOW_DURATION target:self selector:@selector(respondsToTimer:) userInfo:nil repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:_hideTimer forMode:NSRunLoopCommonModes];
}

- (void)showByFade
{
    YSChainAnimator(self.layer)
        .anim(nil, @"opacity")
        .duration(YSTOAST_SHOW_DURATION)
        .from(@(0))
        .to(@(1))
        .hold()
        .run();
}

- (void)hideByFade
{
    YSChainAnimator(self.layer)
        .anim(nil, @"opacity")
        .duration(YSTOAST_SHOW_DURATION)
        .to(@(0))
        .hold()
        .run();
    DispatchAfter(YSTOAST_SHOW_DURATION, ^{
        [self removeFromSuperview];
    });
}

- (void)dealloc
{
    [self.label removeObserverBlockedForKeyPath:@"text"];
    [self.label removeObserverBlockedForKeyPath:@"font"];
    [self removeObserverBlockedForKeyPath:@"margin"];
    [self removeObserverBlockedForKeyPath:@"position"];
}

#pragma mark - Responds methods

- (void)respondsToTimer:(NSTimer *)timer
{
    [self invalidateTimer];
    [self hideByFade];
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviewsWithFrame:self.bounds];
}

- (void)setColor:(UIColor *)color
{
    if (![_color isEqual:color])
    {
        _color = color;
        self.backgroundColor = _color;
    }
}

- (void)setContentColor:(UIColor *)contentColor
{
    if (![_contentColor isEqual:contentColor])
    {
        _contentColor = contentColor;
        self.contentView.backgroundColor = _contentColor;
        ViewShadow(self.contentView, _contentColor, 0.2, 3, CGSizeZero);
    }
}

- (void)setContentCornerRadius:(CGFloat)contentCornerRadius
{
    if (_contentCornerRadius != contentCornerRadius)
    {
        _contentCornerRadius = contentCornerRadius;
        ViewBorderRadius(self.contentView, _contentCornerRadius, 0, nil);
    }
}

@end

@implementation YSToastOnlyText

- (void)setupSubviews
{
    [super setupSubviews];
    self.label.numberOfLines = 3;
}

- (void)layoutSubviewsWithFrame:(CGRect)frame
{
    self.contentView.frame = frame;
    self.label.frame = _CGRect(self.margin, self.margin, frame.size.width-self.margin*2, frame.size.height-self.margin*2);
}

@end

@implementation YSToastIndicator {
    __weak UIActivityIndicatorView *_indicatorView;
    __weak UIImageView *_imageView;
}

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.style = YSToastStyleIndicator;
    _indicatorColor = [UIColor whiteColor];
    
    self.label.numberOfLines = 1;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicatorView.color = _indicatorColor;
    indicatorView.hidesWhenStopped = true;
    [indicatorView startAnimating];
    [self.contentView addSubview:indicatorView];
    _indicatorView = indicatorView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.hidden = true;
    [self.contentView addSubview:imageView];
    _imageView = imageView;
}

- (void)layoutSubviewsWithFrame:(CGRect)frame
{
    if (self.isEnableAccrossInteraction) {
        self.contentView.frame = frame;
    }
    else
    {
        CGSize size = [self contentSize];
        self.contentView.frame = _CGRect(frame.size.width/2-size.width/2, frame.size.height/2-size.height/2, size.width, size.height);
    }
    _indicatorView.frame = _CGRect(self.margin, self.contentView.height/2-INDICATOR_OR_IMAGE_SIZE.height/2, INDICATOR_OR_IMAGE_SIZE.width, INDICATOR_OR_IMAGE_SIZE.height);
    self.label.frame = _CGRect(_indicatorView.right+SPACING_WHEN_INDICATOR, _indicatorView.center.y-self.label.font.lineHeight/2, self.contentView.width-self.margin*2-INDICATOR_OR_IMAGE_SIZE.width-SPACING_WHEN_INDICATOR, self.label.font.lineHeight);
    _imageView.frame = _indicatorView.frame;
}

#pragma mark - Setters/Getters

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    if (![_indicatorColor isEqual:indicatorColor])
    {
        _indicatorColor = indicatorColor;
        _indicatorView.color = indicatorColor;
    }
}

- (void)setEnableAccrossInteraction:(BOOL)enableAccrossInteraction
{
    [super setEnableAccrossInteraction:enableAccrossInteraction];
    if (enableAccrossInteraction) {
        self.backgroundColor = [UIColor clearColor];
    }
    else
    {
        self.backgroundColor = self.color;
    }
}

- (UIImageView *)imageView
{
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView
{
    return _indicatorView;
}

@end


@implementation UIView (Toast)

- (void)makeToast:(NSString *)text
{
    [self makeToast:text afterDelay:1.89f];
}

- (void)makeToast:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    [self makeToast:text position:YSToastPositionBottom afterDelay:delay];
}

- (void)makeToast:(NSString *)text position:(YSToastPosition)position afterDelay:(NSTimeInterval)delay
{
    YSToastOnlyText *toast = [self _currentToast];
    if (!toast)
    {
        toast = [[YSToastOnlyText alloc] init];
        [self addSubview:toast];
        [toast showByFade];
    }
    toast.position = position;
    toast.label.text = text;
    [toast hideAfterDelay:delay];
}

- (YSToastOnlyText *)_currentToast
{
    __block YSToastOnlyText *toast = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:YSToastOnlyText.class])
        {
            toast = (YSToastOnlyText *)obj;
            *stop = true;
        }
    }];
    
    return toast;
}

@end

@implementation UIView (Indicator)

- (void)makeIndicator:(NSString *)text
{
    [self makeIndicator:text enableAccrossInteraction:true];
}

- (void)makeIndicator:(NSString *)text enableAccrossInteraction:(BOOL)yesOrNo
{
    YSToastIndicator *indicator = [self _currentIndicator];
    if (!indicator)
    {
        indicator = [[YSToastIndicator alloc] init];
        indicator.position = YSToastPositionCenter;
        [self addSubview:indicator];
        [indicator showByFade];
    }
    indicator.enableAccrossInteraction = yesOrNo;
    indicator.label.text = text;
}

- (void)makeIndicatorSuccess:(NSString *)reason
{
    [self makeIndicatorSuccess:reason afterDelay:2.26];
}

- (void)makeIndicatorSuccess:(NSString *)reason afterDelay:(NSTimeInterval)delay
{
    [self _updateIndicatorBySuccess:true reason:reason afterDelay:delay];
}

- (void)makeIndicatorFailsure:(NSString *)reason
{
    [self makeIndicatorFailsure:reason afterDelay:2.26];
}

- (void)makeIndicatorFailsure:(NSString *)reason afterDelay:(NSTimeInterval)delay
{
    [self _updateIndicatorBySuccess:false reason:reason afterDelay:delay];
}

- (void)hideIndicator
{
    [[self _currentToast] hideByFade];
}

- (void)_updateIndicatorBySuccess:(BOOL)yesOrNo reason:(NSString *)reason afterDelay:(NSTimeInterval)delay
{
    YSToastIndicator *indicator = [self _currentIndicator];
    if (!indicator)
    {
        indicator = [[YSToastIndicator alloc] init];
        indicator.position = YSToastPositionCenter;
        [self addSubview:indicator];
        [indicator showByFade];
    }
    [[indicator indicatorView] stopAnimating];
    [indicator imageView].hidden = false;
    [indicator imageView].image = [NSBundle imageWithSuccess:yesOrNo];
    indicator.label.text = reason;
    [indicator hideAfterDelay:delay];
}

- (YSToastIndicator *)_currentIndicator
{
    __block YSToastIndicator *indicator = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:YSToastIndicator.class])
        {
            indicator = (YSToastIndicator *)obj;
            *stop = true;
        }
    }];
    
    return indicator;
}

@end
