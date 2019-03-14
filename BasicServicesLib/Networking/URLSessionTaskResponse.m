//
//  URLSessionTaskResponse.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/12.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionTaskResponse.h"
#import <objc/runtime.h>
#import "NSDictionary+KeyValueAddition.h"

@implementation URLSessionTaskResponse
@synthesize response = _response;
@synthesize transferClass = _transferClass;
@synthesize transfered = _transfered;
@synthesize correct = _correct;
@synthesize message = _message;

static char const * kSuccessCodeKeyAdditionAssociateKey = "\0";
static char const * kSuccessCodeAssociateKey = "\1";
+ (void)setResponseSuccessCode:(NSInteger)code forKeyAddition:(NSString *)key
{
    if (key != nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objc_setAssociatedObject(self, kSuccessCodeAssociateKey, @(code), OBJC_ASSOCIATION_COPY);
            objc_setAssociatedObject(self, kSuccessCodeKeyAdditionAssociateKey, key, OBJC_ASSOCIATION_COPY);
        });
    }
}

- (NSString *)getSuccessKeyAddition
{
    return objc_getAssociatedObject([self class], kSuccessCodeKeyAdditionAssociateKey);
}

- (NSInteger)getSuccessCode
{
    return [objc_getAssociatedObject([self class], kSuccessCodeAssociateKey) integerValue];
}

static char const * kErrorMessageKeyAdditionAssociateKey = "\2";
+ (void)setResponseErrorMessageKeyAddition:(NSString *)key
{
    if (key != nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objc_setAssociatedObject(self, kErrorMessageKeyAdditionAssociateKey, key, OBJC_ASSOCIATION_COPY);
        });
    }
}

- (NSString *)getErrorMessageKeyAddition
{
    return objc_getAssociatedObject([self class], kErrorMessageKeyAdditionAssociateKey);
}

- (instancetype)initWithResponse:(NSDictionary *)response class:(Class)transfer
{
    if (response == nil) {
        return nil;
    }
    
    if (self = [super init])
    {
        _response = response;
        _correct = [[response safetyValueForKeyAddition:[self getSuccessKeyAddition]] integerValue] == [self getSuccessCode];
        if (!_correct && [self getErrorMessageKeyAddition]) {
            _message = [response safetyValueForKeyAddition:[self getErrorMessageKeyAddition]];
        }
        if (transfer != NULL)
        {
            _transferClass = transfer;
            // 还差模型转换的代码
        }
    }
    
    return self;
}

@end
