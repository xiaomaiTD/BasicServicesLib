//
//  NSString+Encrypt.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Encrypt)

/// md5方式加密字符串
- (NSString *)md5String;

/// AES加密
- (NSString *)encryptedWithAESUsing:(nonnull NSString *)key iv:(nullable NSData *)iv;
- (NSString *)decryptedWithAESUsing:(nonnull NSString *)key iv:(nullable NSData *)iv;

@end

NS_ASSUME_NONNULL_END
