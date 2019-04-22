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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLSessionTaskResponse : NSObject

/// 网络请求成功的判断条件。code表示值为多少时为正确请求，key表示code的取值路径。
+ (void)setResponseSuccessCode:(NSInteger)code forKeyAddition:(NSString *)key;
/// 网络请求失败时的错误信息取值路径。
+ (void)setResponseErrorMessageKeyAddition:(NSString *)key;

- (instancetype)initWithResponse:(NSDictionary * _Nonnull)response class:(Class _Nullable)transfer;

@property(strong, nonatomic, readonly) NSDictionary *response;
@property(assign, nonatomic, readonly) Class transferClass;
@property(strong, nonatomic, readonly) id transfered;
@property(assign, nonatomic, readonly) BOOL correct;
@property(nullable, strong, nonatomic, readonly) NSString *message;

@end

NS_ASSUME_NONNULL_END
