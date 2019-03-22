//
//  NSDate+NSCalendar.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (NSCalendar)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)nanosecond;
- (NSInteger)weekday;

- (BOOL)isLeapYear;
- (BOOL)isLeapMonth;

@end

NS_ASSUME_NONNULL_END
