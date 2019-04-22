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

#import "DecimalUtil.h"

NSString * const kAmountNormalUnitName = @"元";
NSString * const kAmountThousandUnitName = @"万";
NSString * const kAmountBillionUnitName = @"亿";
NSString * const kAmountTeraUnitName = @"万亿";

static NSString * const kRMBType = @"￥";
static NSString * const kDollarType = @"$";

static NSDecimalNumber *decimal_commom_cacl(NSDecimalNumber *aDecimal, NSUInteger scale,  BOOL usingUnit)
{
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *resultDecimal = nil;
    
    if (usingUnit)
    {
        double decimalValue = [aDecimal doubleValue];
        if (decimalValue / 10000 < 1) {
            resultDecimal = [aDecimal decimalNumberByRoundingAccordingToBehavior:numberHandler];
        }
        else if (decimalValue / 100000000 < 1)
        {
            resultDecimal = [aDecimal decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:numberHandler];
        }
        else if (decimalValue / 1000000000000 < 1)
        {
            resultDecimal = [aDecimal decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100000000"] withBehavior:numberHandler];
        }
        else
        {
            resultDecimal = [aDecimal decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000"] withBehavior:numberHandler];
        }
    }
    else
    {
        resultDecimal = [aDecimal decimalNumberByRoundingAccordingToBehavior:numberHandler];
    }
    
    return resultDecimal;
}

static NSString *decimal_amount_unit(NSDecimalNumber *aDecimal, BOOL usingUnit)
{
    NSString *unit = nil;
    
    if (usingUnit)
    {
        double decimalValue = [aDecimal doubleValue];
        if (decimalValue / 10000 < 1) {
            unit = kAmountNormalUnitName;
        }
        else if (decimalValue / 100000000 < 1)
        {
            unit = kAmountThousandUnitName;
        }
        else if (decimalValue / 1000000000000 < 1)
        {
            unit = kAmountBillionUnitName;
        }
        else
        {
            unit = kAmountTeraUnitName;
        }
    }
    
    return unit;
}

static NSString *decimal_amount_type(NSDecimalNumber *aDecimal, AmountType type, NSUInteger scale)
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = @"###,###";
    for (int i = 0; i < scale; i ++)
    {
        if (i == 0) {
            numberFormatter.positiveFormat = [numberFormatter.positiveFormat stringByAppendingString:@"."];
        }
        numberFormatter.positiveFormat = [numberFormatter.positiveFormat stringByAppendingString:@"0"];
    }
    
    NSString *resultString = [numberFormatter stringFromNumber:aDecimal];
    
    if (type == AmountTypeNone) {
        // 什么都不做
    }
    else if (type == AmountTypeRMB)
    {
        resultString = [kRMBType stringByAppendingString:resultString];
    }
    else if (type == AmountTypeDollar)
    {
        resultString = [kDollarType stringByAppendingString:resultString];
    }
    
    return resultString;
}

@implementation DecimalUtil

+ (NSString *)amountFromDecimal:(NSDecimalNumber *)aDecimal scale:(NSUInteger)scale type:(AmountType)type usingUnit:(BOOL)usingUnit
{
    NSString *unit = decimal_amount_unit(aDecimal, usingUnit);
    NSDecimalNumber *resultDecimal = decimal_commom_cacl(aDecimal, scale, usingUnit);
    NSString *typedString = decimal_amount_type(resultDecimal, type, scale);
    
    if (unit) {
        return [typedString stringByAppendingString:unit];
    }
    
    return typedString;
}

+ (NSString *)percentFromDecimal:(NSDecimalNumber *)aDecimal
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    return [numberFormatter stringFromNumber:aDecimal];
}

@end
