//
//  URLSessionTaskParams.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionTaskParams.h"

@implementation URLSessionTaskParams
@synthesize params = _params;

- (instancetype)initWithParams:(id)params
{
    if (self = [super init])
    {
        _serializer = URLSessionTaskSerializerJSON;
        _params = params;
    }
    return self;
}

- (BOOL)isEqual:(URLSessionTaskParams *)object
{
    return [self.params isEqual:object.params] && [self.header isEqualToDictionary:object.header];
}

@end
