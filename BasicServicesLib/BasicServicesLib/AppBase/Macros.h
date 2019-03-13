//
//  Macros.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#import "Constants.h"

#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#ifdef DEBUG
    #define DEV_LOG(...) NSLog(__VA_ARGS__)
#else
    #define DEV_LOG(...)
#endif

#define ViewBorderRadius(View, Radius, Width, Color)    [View.layer setCornerRadius:(Radius)];\
                                                        [View.layer setBorderWidth:(Width)];\
                                                        [View.layer setBorderColor:[Color CGColor]]

#define ViewShadow(View, Color, Opacity, Radius, Offset)        View.layer.shadowColor = Color.CGColor;\
                                                                View.layer.shadowOpacity = Opacity;\
                                                                View.layer.shadowRadius = Radius;\
                                                                View.layer.shadowOffset = Offset

#define DispatchAfter(Delay, AfterBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay * NSEC_PER_SEC)),\
                                                        dispatch_get_main_queue(), \
                                                        AfterBlock)

#define NSStringFormat(Format, ...)      [NSString stringWithFormat:Format, ## __VA_ARGS__]
#define NSStringFromUTF8(Char)           [NSString stringWithUTF8String:Char]

#define ColorRGBA(r, g, b, a)       [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define ColorRGB(r, g, b)           ColorRGBA(r, g, b, 1.0)
#define ColorRandom()               ColorRGB((arc4random() % 255), (arc4random() % 255), (arc4random() % 255))

#define ImageNamed(Named)   [UIImage imageNamed:Named]

#define NotificationCenter  [NSNotificationCenter defaultCenter]

#define ScreenBounds        ([UIScreen mainScreen].bounds)
#define ScreenWidth         RectWidth(ScreenBounds)
#define ScreenHeight        RectHeight(ScreenBounds)
#define ScreenScale         ([UIScreen mainScreen].scale)

#define SysVersion          ([[UIDevice currentDevice] systemVersion])
#define AppDelegate         ([UIApplication sharedApplication].delegate)
#define AppStatusBarHeight  (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

#endif /* Macros_h */
