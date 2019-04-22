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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

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
    return 180.0*(radian)/M_PI;
}

/**
 * 字符串是否为空，长度为0、null对象、nil都返回YES。
 */
extern BOOL StringIsEmpty(NSString *string);

/**
 * 数组是否为空，null对象、count为0、nil都返回YES。
 */
extern BOOL ArrayIsEmpty(NSArray *array);

/**
 * 字典是否为空，null对象、元素个数为0、nil都返回YES。
 */
extern BOOL DictionaryIsEmpty(NSDictionary *dict);

extern UIColor *ColorRGBA(double red, double green, double blue, double alpha);

extern UIColor *ColorRGB(double red, double green, double blue);

extern UIColor *ColorRandom(void);

/**
 * [UIFont systemFontOfSize:(size)]
 */
extern UIFont *FontOfSize(CGFloat size);

/**
 * [UIFont boldSystemFontOfSize:(size)]
 */
extern UIFont *FontOfBlodSize(CGFloat size);

/**
 * 数组倒序。如果传入的数组是可变类型，则得到的也是可变类型的数据。
 */
extern NSArray *ArrayReversed(NSArray *array);

/**
 * 获取存放数字的数组中的最大/小值。
 */
extern NSNumber *MaxNumberInArray(NSArray<NSNumber *> *numbers);

extern NSNumber *MinNumberInArray(NSArray<NSNumber *> *numbers);

/**
 * 将cls类的对象方法selector1，替换为slector2。
 */
extern void ExchangeMethod(Class cls, SEL selector1, SEL selector2);

/**
 * 通过底部安全区高度判断。除了刘海屏以外，不管横屏竖屏，底部安全区高度都为0。
 */
extern BOOL IsiPhoneXScreen(void);

/**
 * 给视图target添加阴影。 shadowRadius在CA框架中默认为3。
 */
extern void ViewShadow(UIView *target, UIColor *shadowColor, double shadowOpacity, double shadowRadius, CGSize shadowOffset);

/**
 * 给视图target设置边框属性。
 */
extern void ViewBorderRadius(UIView *target, double cornerRadius, double borderWidth, UIColor *borderColor);

/**
 * 发送通知。
 */
extern void NotificationCenterPost(NSString * _Nonnull name, id _Nullable obj, NSDictionary * _Nullable userInfo);

/**
 * 添加通知观察者。
 */
extern void NotificationCenterAddObserver(NSString * _Nullable name, id _Nonnull observer, SEL _Nonnull selector, id _Nullable obj);

/**
 * 移除通知观察者。
 */
extern void NotificationCenterRemoveObserver(NSString * _Nullable name, id _Nonnull observer, id _Nullable obj);

/**
 * dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
 */
extern void DispatchGlobal(dispatch_block_t block);

/**
 * dispatch_async(dispatch_get_main_queue(), block)
 */
extern void DispatchMain(dispatch_block_t block);

/**
 * dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block)
 */
extern void DispatchAfter(double delay, dispatch_block_t block);
