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
