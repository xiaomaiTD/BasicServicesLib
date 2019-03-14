//
//  URLSessionTaskURL.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/7.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "URLSessionTaskURL.h"
#import "Macros.h"

@implementation URLSessionTaskURL {
    NSString *_URLString;
    NSURL *_URL;
}
@synthesize baseURL = _baseURL;
@synthesize relativeURL = _relativeURL;

static BOOL is_url(NSString *URLString)
{
    NSString *URL = URLString;
    if (URLString.length > 4 && [[URLString substringToIndex:4] isEqualToString:@"www."]) {
        URL = [NSString stringWithFormat:@"http://%@", URLString];
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:URL];
}


- (instancetype)initWithBaseURL:(NSString *)baseURL relativeURL:(nonnull NSString *)relativeURL
{
    if (self = [super init])
    {
        _baseURL = baseURL;
        _relativeURL = relativeURL;
        
        NSString *baseURL = _baseURL;
        if ([_baseURL hasSuffix:@"/"]) {
            baseURL = [baseURL substringToIndex:_baseURL.length-2];
        }
        NSString *relativeURL = _relativeURL;
        if ([_relativeURL hasPrefix:@"/"]) {
            relativeURL = [relativeURL substringFromIndex:1];
        }
        NSString *URLString = NSStringFormat(@"%@/%@", baseURL, relativeURL);
        if (is_url(URLString)) {
            _URLString = URLString;
        }
        
        _URL = [NSURL URLWithString:[self URLString]];
    }
    return self;
}

- (BOOL)isEqual:(URLSessionTaskURL *)object
{
    return [_URLString isEqualToString:object->_URLString];
}

- (NSString *)URLString
{
    return _URLString;
}

- (NSURL *)URL
{
    return _URL;
}

- (NSString *)description
{
    return _URLString != nil ? _URLString:NSStringFormat(@"baseURL = %@, relativeURL = %@", _baseURL, _relativeURL);
}

@end
