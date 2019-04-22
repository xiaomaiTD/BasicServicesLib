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
