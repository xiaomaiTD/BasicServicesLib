//
//  DecimalUtil.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
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
