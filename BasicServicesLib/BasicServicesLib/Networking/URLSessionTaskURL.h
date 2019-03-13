//
//  URLSessionTaskURL.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLSessionTaskURL : NSObject

- (instancetype)initWithBaseURL:(NSString *)baseURL relativeURL:(NSString *)relativeURL;

@property(strong, nonatomic, readonly) NSString *baseURL;
@property(strong, nonatomic, readonly) NSString *relativeURL;

- (NSString *)URLString;
- (NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
