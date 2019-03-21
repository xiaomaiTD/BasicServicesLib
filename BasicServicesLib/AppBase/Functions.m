//
//  Functions.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/18.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "Functions.h"
#import "Macros.h"

BOOL StringIsEmpty(NSString *string)
{
    return [string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1 ? YES:NO;
}

BOOL ArrayIsEmpty(NSArray *array)
{
    return [array isKindOfClass:[NSNull class]] || array == nil || array.count == 0  ? YES:NO;
}

BOOL DictionaryIsEmpty(NSDictionary *dict)
{
    return [dict isKindOfClass:[NSNull class]] || dict == nil || dict.allKeys.count == 0 ? YES:NO;
}

UIColor *ColorRGBA(double red, double green, double blue, double alpha)
{
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

UIColor *ColorRGB(double red, double green, double blue)
{
    return ColorRGBA(red, green, blue, 1.0);
}

UIColor *ColorRandom(void)
{
    return ColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
}

UIFont *FontOfSize(CGFloat size)
{
    return [UIFont systemFontOfSize:size];
}

UIFont *FontOfBlodSize(CGFloat size)
{
    return [UIFont boldSystemFontOfSize:size];
}

NSArray *ArrayReversed(NSArray *array)
{
    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    if ([array isKindOfClass:[NSMutableArray class]]) {
        return [NSMutableArray arrayWithArray:reversed];
    }
    return reversed;
}

NSNumber *MaxNumberInArray(NSArray<NSNumber *> *numbers)
{
    return [numbers valueForKeyPath:@"@max.self"];
}

NSNumber *MinNumberInArray(NSArray<NSNumber *> *numbers)
{
    return [numbers valueForKeyPath:@"@min.self"];
}

void ExchangeMethod(Class cls, SEL selector1, SEL selector2)
{
    method_exchangeImplementations(class_getInstanceMethod(cls, selector1), class_getInstanceMethod(cls, selector2));
}

BOOL IsiPhoneXScreen(void)
{
    static dispatch_once_t onceToken;
    static BOOL result = NO;
    dispatch_once(&onceToken, ^{
        // Refer: https://kangzubin.com/iphonex-detect/
        if (@available(iOS 11.0, *))
        {
            CGFloat bottomSafeAreaInset = KeyWindow.safeAreaInsets.bottom;
            if (bottomSafeAreaInset == kiPhoneXScreenBottomSafeAreaHeight) {
                result = YES;
            }
        }
    });
    return result;
}

void ViewShadow(UIView *target, UIColor *shadowColor, double shadowOpacity, double shadowRadius, CGSize shadowOffset)
{
    [target.layer setShadowColor:[shadowColor CGColor]];
    [target.layer setShadowOpacity:shadowOpacity];
    [target.layer setShadowRadius:shadowRadius];
    [target.layer setShadowOffset:shadowOffset];
}

void ViewBorderRadius(UIView *target, double cornerRadius, double borderWidth, UIColor *borderColor)
{
    [target.layer setCornerRadius:cornerRadius];
    [target.layer setBorderWidth:borderWidth];
    [target.layer setBorderColor:[borderColor CGColor]];
}

void NotificationCenterPost(NSString *name, id obj, NSDictionary *userInfo)
{
    [NotificationCenter postNotificationName:name object:obj userInfo:userInfo];
}

void NotificationCenterAddObserver(NSString *name, id observer, SEL selector, id obj)
{
    [NotificationCenter addObserver:observer selector:selector name:name object:obj];
}

void NotificationCenterRemoveObserver(NSString *name, id observer, id obj)
{
    [NotificationCenter removeObserver:observer name:name object:obj];
}

void DispatchGlobal(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void DispatchMain(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void DispatchAfter(double delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
