//
//  TimeUtil.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "TimeUtil.h"

NSString * const kDateFormatter = @"yyyy-MM-dd";
NSString * const kTimeFormatter = @"yyyy-MM-dd HH:mm:ss";

@implementation TimeUtil

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromTimestamp:(NSTimeInterval)timestamp format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    return [self stringFromDate:date format:format];
}

+ (NSDate *)dateFromString:(NSString *)aString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:aString];
}

+ (NSTimeInterval)timestampFromString:(NSString *)aString format:(NSString *)format
{
    NSDate *date = [self dateFromString:aString format:format];
    return [date timeIntervalSince1970];
}

@end
