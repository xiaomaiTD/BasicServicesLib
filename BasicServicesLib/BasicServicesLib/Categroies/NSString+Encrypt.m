//
//  NSString+Encrypt.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Encrypt.h"
#import "NSData+Base64.h"

@implementation NSString (Encrypt)

- (NSString *)md5String
{
    const char *cStr = self.UTF8String;
    if (cStr == NULL) {
        cStr = "";
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)encryptedWithAESUsing:(NSString *)key iv:(NSData *)iv
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data encryptedWithAESUsingKey:key iv:iv];
    return [encryptedData base64EncodedString];
}

- (NSString *)decryptedWithAESUsing:(NSString *)key iv:(NSData *)iv
{
    NSData *data = [NSData dataWithBase64EncodedString:self];
    NSData *decryptedData = [data decryptedWithAESUsingKey:key iv:iv];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
