//
//  NSData+Encrypt.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encrypt)

/// 使用AES方式加密数据
- (NSData *)encryptedWithAESUsingKey:(nonnull NSString *)key iv:(nullable NSData *)iv;
- (NSData *)decryptedWithAESUsingKey:(nonnull NSString *)key iv:(nullable NSData *)iv;

@end

NS_ASSUME_NONNULL_END
