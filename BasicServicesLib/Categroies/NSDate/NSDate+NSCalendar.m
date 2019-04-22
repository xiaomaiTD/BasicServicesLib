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
