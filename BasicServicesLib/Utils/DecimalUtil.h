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

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kAmountNormalUnitName; // 元
extern NSString * const kAmountThousandUnitName; // 万
extern NSString * const kAmountBillionUnitName; // 亿
extern NSString * const kAmountTeraUnitName;  // 万亿

typedef NS_ENUM(NSInteger, AmountType) {
    AmountTypeNone,   // 不要
    AmountTypeRMB,    // ￥
    AmountTypeDollar  // $
};

@interface DecimalUtil : NSObject

/// 当需要自动转换单位时，由于scale的小数位数导致四舍五入时单位越大差异越大
+ (NSString *)amountFromDecimal:(nonnull NSDecimalNumber *)aDecimal scale:(NSUInteger)scale type:(AmountType)type usingUnit:(BOOL)usingUnit;

/// 得到对应的百分比字符串
+ (NSString *)percentFromDecimal:(nonnull NSDecimalNumber *)aDecimal;

@end

NS_ASSUME_NONNULL_END
