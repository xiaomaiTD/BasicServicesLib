//
//  NSDate+NSCalendar.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "NSDate+NSCalendar.h"

@implementation NSDate (NSCalendar)

static NSDateComponents *components_fromDate(NSCalendarUnit units, NSDate *date)
{
    return [[NSCalendar currentCalendar] components:units fromDate:date];
}

- (NSInteger)year
{
    return [components_fromDate(NSCalendarUnitYear, self) year];
}

- (NSInteger)month
{
    return [components_fromDate(NSCalendarUnitMonth, self) month];
}

- (NSInteger)day
{
    return [components_fromDate(NSCalendarUnitDay, self) day];
}

- (NSInteger)hour
{
    return [components_fromDate(NSCalendarUnitHour, self) hour];
}

- (NSInteger)minute
{
    return [components_fromDate(NSCalendarUnitMinute, self) minute];
}

- (NSInteger)second
{
    return [components_fromDate(NSCalendarUnitSecond, self) second];
}

- (NSInteger)nanosecond
{
    return [components_fromDate(NSCalendarUnitNanosecond, self) nanosecond];
}

- (NSInteger)weekday
{
    return [components_fromDate(NSCalendarUnitWeekday, self) weekday];
}

- (BOOL)isLeapYear
{
    NSInteger year = [self year];
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isLeapMonth
{
    return [components_fromDate(NSCalendarUnitQuarter, self) isLeapMonth];
}

@end
