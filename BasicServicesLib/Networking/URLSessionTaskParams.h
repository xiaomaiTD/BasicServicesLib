//
//  URLSessionTaskParams.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary<NSString*, NSString*> * URLSessionTaskHTTPHeader;

typedef NS_ENUM(NSInteger, URLSessionTaskSerializer) {
    URLSessionTaskSerializerJSON,
    URLSessionTaskSerializerSTRING,
    URLSessionTaskSerializerHTTP
};

@interface URLSessionTaskParams : NSObject

- (instancetype)initWithParams:(id)params;

@property(strong, nonatomic, readonly) id params;
/// 请求的参数编码，默认为JSON
@property(assign, nonatomic) URLSessionTaskSerializer serializer;
@property(strong, nonatomic) URLSessionTaskHTTPHeader header;

@end

NS_ASSUME_NONNULL_END
