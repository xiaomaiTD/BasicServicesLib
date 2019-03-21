//
//  Macros.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "Functions.h"

#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif

#ifndef Macros_h
#define Macros_h

/**
 * Refer: https://onevcat.com/2014/01/black-magic-in-macro/
 */
#define NSLog(Format, ...) do {                                                                             \
                                fprintf(stderr, "<%s : %d> %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __func__);                                       \
                                (NSLog)((Format), ##__VA_ARGS__);                                           \
                                fprintf(stderr, "-------\n");                                               \
                           } while (0)

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
#define Swap(_A_, _B_)  do { __typeof(_A_) _tmp_ = (_A_); (_A_) = (_B_); (_B_) = _tmp_; } while(0)

/**
 * 使用这个宏来获取对象时，Named包含了文件格式。
 */
#define ImageWithContentsFile(Named)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Named ofType:nil]]
#define ArrayWithContentsFile(Named)        [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Named ofType:nil]]
#define DictionaryWithContentsFile(Named)   [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Named ofType:nil]]


#define ImageNamed(Named)   [UIImage imageNamed:Named]
#define NotificationCenter  [NSNotificationCenter defaultCenter]
#define UserDefaults        [NSUserDefaults standardUserDefaults]
#define Application         [UIApplication sharedApplication]
#define _AppDelegate        Application.delegate
#define KeyWindow           Application.keyWindow
#define InfoDictionary      [[NSBundle mainBundle] infoDictionary]
#define AppNamed            [InfoDictionary objectForKey:@"CFBundleName"]
#define AppIdentifier       [InfoDictionary objectForKey:@"CFBundleIdentifier"]
#define AppVersion          [InfoDictionary objectForKey:@"CFBundleShortVersionString"]
#define AppBuild            [InfoDictionary objectForKey:@"CFBundleVersion"]

#define DocumentPath                (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])
#define TempPath                    (NSTemporaryDirectory())
#define CachePath                   (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])
#define CurrentLanguage             ([NSLocale preferredLanguages][0])
#define kToastDefaultDismissDelay   (2.3)
#define kResultHUDDismissDelay      (1.45)
#define kNavigationBarHeight        (44.0)
#define kScreenBounds               ([UIScreen mainScreen].bounds)
#define kScreenScale                ([UIScreen mainScreen].scale)
#define kAppStatusBarHeight         (CGRectGetHeight(Application.statusBarFrame))
#define kScreenWidth                (CGRectGetWidth(ScreenBounds))
#define kScreenHeight               (CGRectGetHeight(ScreenBounds))
#define kSysVersion                 ([[UIDevice currentDevice] systemVersion])

#define iOS9OrLater         (([kSysVersion floatValue] >= 9.0) ? (YES):(NO))
#define iOS10OrLater        (([kSysVersion floatValue] >= 10.0) ? (YES):(NO))
#define iOS11OrLater        (([kSysVersion floatValue] >= 11.0) ? (YES):(NO))

/**
 * 检测是否是竖屏状态
 */
#define kIsPortrait (Application.statusBarOrientation == UIInterfaceOrientationPortrait || Application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

/**
 * 刘海屏幕的底部安全区高度，适配了横屏和竖屏两种。
 */
#define kiPhoneXScreenBottomSafeAreaHeight  (kIsPortrait ? 34.0:21.0)


/**
 * Refer: https://www.jianshu.com/p/9e18f28bf28d
 */
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

#endif /* Macros_h */
