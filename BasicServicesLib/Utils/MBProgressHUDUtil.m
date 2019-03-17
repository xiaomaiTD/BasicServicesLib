//
//  MBProgressHUDUtil.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "MBProgressHUDUtil.h"
#import "Macros.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSBundle+BasicServicesLibResource.h"

@interface NSBundle (MBProgressHUD)

+ (UIImage *)HUDBlackErrorImage;
+ (UIImage *)HUDWhiteErrorImage;

+ (UIImage *)HUDBlackSuccessImage;
+ (UIImage *)HUDWhiteSuccessImage;

@end

@implementation NSBundle (MBProgressHUD)

+ (UIImage *)HUDBlackErrorImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"hud_loading_error_blak@3x":@"hud_loading_error_blak@2x");
        NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
        image = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)HUDWhiteErrorImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"hud_loading_error_white@3x":@"hud_loading_error_white@2x");
        NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
        image = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)HUDBlackSuccessImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"hud_loading_success_blak@3x":@"hud_loading_success_blak@2x");
        NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
        image = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)HUDWhiteSuccessImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"hud_loading_white@3x":@"hud_loading_white@2x");
        NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
        image = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end


#define DefaultContentBackgroundColor   [UIColor colorWithWhite:0 alpha:0.8]
#define DefaultLableFont                [UIFont systemFontOfSize:14]

@implementation MBProgressHUDUtil

static UIView *get_superView(UIView *aView)
{
    UIView *superView = aView;
    if (superView == nil) {
        superView = AppDelegate.window;
    }
    return superView;
}

static MBProgressHUD *get_defaultHUD(UIView *superView, NSString *text)
{
    MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    toast.removeFromSuperViewOnHide = YES;
    toast.margin = 15;
    toast.label.numberOfLines = 3;
    toast.label.font = DefaultLableFont;
    toast.label.text = text;
    toast.bezelView.layer.cornerRadius = 10;
    [superView addSubview:toast];
    return toast;
}

static void dismiss_exsitHUD(UIView *superView)
{
    MBProgressHUD *exsitHUD = [MBProgressHUD HUDForView:superView];
    if (exsitHUD)
    {
        if (exsitHUD.mode != MBProgressHUDModeText) {
            [exsitHUD hideAnimated:NO];
        }
    }
}

static void set_commonHUDConfigration(MBProgressHUD *hud, UIColor *color, bool mask)
{
    BOOL isColorNotNil = color != nil;
    hud.bezelView.style = isColorNotNil ? MBProgressHUDBackgroundStyleSolidColor : MBProgressHUDBackgroundStyleBlur;
    
    if (isColorNotNil) {
        hud.bezelView.color = color;
    }else {
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
            hud.bezelView.color = [UIColor colorWithWhite:0.8f alpha:0.6f];
        } else {
            hud.bezelView.color = [UIColor colorWithWhite:0.95f alpha:0.6f];
        }
    }
    
    hud.label.textColor = isColorNotNil ? UIColor.whiteColor : UIColor.blackColor;
    
    UIActivityIndicatorViewStyle style = isColorNotNil ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
    if (@available(iOS 9, *)) {
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].activityIndicatorViewStyle = style;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].activityIndicatorViewStyle = style;
#pragma clang diagnostic pop
    }
    
    if (mask) {
        hud.backgroundView.color = [UIColor colorWithWhite:0 alpha:0.3];
    }
}

+ (void)ToastWithText:(nonnull NSString *)text inView:(nullable UIView *)aView atPosition:(ToastPosition)position dismissAfter:(CGFloat)delay
{
    UIView *superView = get_superView(aView);
    
    MBProgressHUD *toast = get_defaultHUD(superView, text);
    toast.userInteractionEnabled = NO;
    toast.mode = MBProgressHUDModeText;
    if (position == ToastPositionBottom) {
        toast.offset = _CGPoint(0, MBProgressMaxOffset);
    }
    toast.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    toast.bezelView.color = DefaultContentBackgroundColor;
    toast.label.textColor = UIColor.whiteColor;
    [toast hideAnimated:YES afterDelay:delay];
}

+ (void)ToastWithText:(NSString *)text inView:(UIView *)aView
{
    [self ToastWithText:text inView:aView atPosition:ToastPositionCenter dismissAfter:kToastDefaultDismissDelay];
}

+ (void)LoadingWithText:(NSString *)text inView:(UIView *)aView contentBackgroundColor:(UIColor *)color maskBackground:(BOOL)mask userInteraction:(BOOL)enable
{
    UIView *superView = get_superView(aView);
    dismiss_exsitHUD(superView);
    
    MBProgressHUD *loading = get_defaultHUD(superView, text);
    loading.userInteractionEnabled = !enable;
    loading.mode = MBProgressHUDModeIndeterminate;
    set_commonHUDConfigration(loading, color, mask);
}

+ (void)LoadingWithText:(NSString *)text inView:(UIView *)aView contentBackgroundColor:(UIColor *)color maskBackground:(BOOL)mask
{
    [self LoadingWithText:text inView:aView contentBackgroundColor:color maskBackground:mask userInteraction:YES];
}

+ (void)LoadingWithText:(NSString *)text inView:(UIView *)aView
{
    [self LoadingWithText:text inView:aView contentBackgroundColor:DefaultContentBackgroundColor maskBackground:NO];
}

+ (void)ResultWithText:(NSString *)text inView:(UIView *)aView resultImage:(UIImage *)image contentBackgroundColor:(UIColor *)color maskBackground:(BOOL)mask
{
    UIView *superView = get_superView(aView);
    dismiss_exsitHUD(superView);
    
    MBProgressHUD *success = get_defaultHUD(superView, text);
    success.mode = MBProgressHUDModeCustomView;
    success.customView =  [[UIImageView alloc] initWithImage:image];
    set_commonHUDConfigration(success, color, mask);
    [success hideAnimated:YES afterDelay:kResultHUDDismissDelay];
}

+ (void)SuccessWithText:(NSString *)text inView:(UIView *)aView contentBackgroundColor:(UIColor *)color maskBackground:(BOOL)mask
{
    [self ResultWithText:text inView:aView resultImage:color != nil ? [NSBundle HUDWhiteSuccessImage]:[NSBundle HUDBlackSuccessImage] contentBackgroundColor:color maskBackground:mask];
}

+ (void)SuccessWithText:(NSString *)text inView:(UIView *)aView
{
    [self SuccessWithText:text inView:aView contentBackgroundColor:DefaultContentBackgroundColor maskBackground:NO];
}

+ (void)ErrorWithText:(NSString *)text inView:(UIView *)aView contentBackgroundColor:(UIColor *)color maskBackground:(BOOL)mask
{
    [self ResultWithText:text inView:aView resultImage:color != nil ? [NSBundle HUDWhiteErrorImage]:[NSBundle HUDBlackErrorImage] contentBackgroundColor:color maskBackground:mask];
}

+ (void)ErrorWithText:(NSString *)text inView:(UIView *)aView
{
    [self ErrorWithText:text inView:aView contentBackgroundColor:DefaultContentBackgroundColor maskBackground:NO];
}

@end
