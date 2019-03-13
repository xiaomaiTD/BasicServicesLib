//
//  TimeUtil.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * NSDate， NSString ， Timestamp
 */

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDateFormatter; // yyyy-MM-dd
extern NSString * const kTimeFormatter; // yyyy-MM-dd HH:mm:ss

@interface TimeUtil : NSObject

+ (NSString *)stringFromDate:(nonnull NSDate *)date format:(nonnull NSString *)format;
+ (NSString *)stringFromTimestamp:(NSTimeInterval)timestamp format:(nonnull NSString *)format;

+ (NSDate *)dateFromString:(nonnull NSString *)aString format:(nonnull NSString *)format;

+ (NSTimeInterval)timestampFromString:(nonnull NSString *)aString format:(nonnull NSString *)format;

@end

NS_ASSUME_NONNULL_END
