//
//  NSData+Base64.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(nullable NSString *)aString;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END
