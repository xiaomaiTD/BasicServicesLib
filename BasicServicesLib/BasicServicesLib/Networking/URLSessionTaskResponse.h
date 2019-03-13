//
//  URLSessionTaskResponse.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/12.
//  Copyright © 2019 Luckeyhill. All rights reserved.
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
