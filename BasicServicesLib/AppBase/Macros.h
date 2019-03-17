//
//  Macros.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#ifndef Macros_h
#define Macros_h

#define NSLog(FORMAT, ...) fprintf(stderr,"%s 第%d行 %s\t%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __FUNCTION__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#ifdef DEBUG
    #define DEV_LOG(...) NSLog(__VA_ARGS__)
#else
    #define DEV_LOG(...)
#endif

#if TARGET_OS_IPHONE
    #define LOG(...)
#elif TARGET_IPHONE_SIMULATOR
    #define LOG(...)    DEV_LOG(__VA_ARGS__)
#endif

#define NSStringFormat(Format, ...)      [NSString stringWithFormat:Format, ##__VA_ARGS__]
#define NSStringFromUTF8(Char)           [NSString stringWithUTF8String:Char]

#define ImageNamed(Named)   [UIImage imageNamed:Named]
#define NotificationCenter  [NSNotificationCenter defaultCenter]
#define AppDelegate         ([UIApplication sharedApplication].delegate)
#define InfoDictionary      [[NSBundle mainBundle] infoDictionary]
#define AppNamed            [InfoDictionary objectForKey:@"CFBundleDisplayName"]
#define AppVersion          [InfoDictionary objectForKey:@"CFBundleShortVersionString"]
#define AppBuild            [InfoDictionary objectForKey:@"CFBundleVersion"]
#define DocumentPath        (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])
#define TempPath            NSTemporaryDirectory()
#define CachePath           (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])
#define CurrentLanguage     ([NSLocale preferredLanguages][0])

#define kNavigationBarHeight        (44.0)
#define kToastDefaultDismissDelay   (2.3)
#define kResultHUDDismissDelay      (1.45)
#define kScreenBounds        ([UIScreen mainScreen].bounds)
#define kScreenScale         ([UIScreen mainScreen].scale)
#define kAppStatusBarHeight  (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define kScreenWidth         CGRectGetWidth(ScreenBounds)
#define kScreenHeight        CGRectGetHeight(ScreenBounds)
#define kSysVersion          ([[UIDevice currentDevice] systemVersion])

#pragma mark -  强弱引用

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(Object) autoreleasepool{} __weak __typeof__(Object) weak##_##Object = Object;
        #else
        #define weakify(Object) autoreleasepool{} __block __typeof__(Object) block##_##Object = Object;
        #endif
    #else
        #if __has_feature(objec_arc)
        #define weakify(Object) try{} @finally{} {} __weak __typeof__(Object) weak##_##Object = Object;
        #else
        #define weakify(Object) try{} @finally{} {} __block __typeof__(Object) block##_##Object = Object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(Object) autoreleasepool{} __typeof__(Object) Object = weak##_##Object;
        #else
        #define strongify(Object) autoreleasepool{} __typeof__(Object) Object = block##_##Object;
        #endif
    #else
        #if __has_feature(objec_arc)
        #define strongify(Object) try{} @finally{} {} __typeof__(Object) Object = weak##_##Object;
        #else
        #define strongify(Object) try{} @finally{} {} __typeof__(Object) Object = block##_##Object;
        #endif
    #endif
#endif

#pragma mark - 内敛函数

static inline CGRect _CGRect(double x, double y, double w, double h)
{
    return CGRectMake(x, y, w, h);
}

static inline CGPoint _CGPoint(double x, double y)
{
    return CGPointMake(x, y);
}

static inline CGSize _CGSize(double w, double h)
{
    return CGSizeMake(w, h);
}

static inline UIEdgeInsets _UIEdgeInsets(double t, double l, double b, double r)
{
    return UIEdgeInsetsMake(t, l, b, r);
}

static inline double DegreesToRadian(double degrees)
{
    return M_PI*(degrees)/180.0;
}

static inline double RadianToDegrees(double radian)
{
    return (radian*180.0)/(M_PI);
}

static inline BOOL StringIsEmpty(NSString *string)
{
    return [string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1 ? YES : NO;
}

static inline UIColor *ColorRGBA(double red, double green, double blue, double alpha)
{
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

static inline UIColor *ColorRGB(double red, double green, double blue)
{
    return ColorRGBA(red, green, blue, 1.0);
}

static inline UIColor *ColorRandom(void)
{
    return ColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
}

static inline void ExchangeMethod(Class cls, SEL selector1, SEL selector2)
{
    method_exchangeImplementations(class_getInstanceMethod(cls, selector1), class_getInstanceMethod(cls, selector2));
}


static inline void ViewShadow(UIView *target, UIColor *shadowColor, double shadowOpacity, double shadowRadius, CGSize shadowOffset)
{
    [target.layer setShadowColor:[shadowColor CGColor]];
    [target.layer setShadowOpacity:shadowOpacity];
    [target.layer setShadowRadius:shadowRadius];
    [target.layer setShadowOffset:shadowOffset];
}

static inline void ViewBorderRadius(UIView *target, double cornerRadius, double borderWidth, UIColor *borderColor)
{
    [target.layer setCornerRadius:cornerRadius];
    [target.layer setBorderWidth:borderWidth];
    [target.layer setBorderColor:[borderColor CGColor]];
}

static inline void DispatchAfter(double delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

#endif /* Macros_h */
