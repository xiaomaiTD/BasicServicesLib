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

#import "NSBundle+BasicServicesLibResource.h"
#import "SqliteDatabase.h"
#import "Macros.h"

@implementation NSBundle (BasicServicesLibResource)

+ (instancetype)basicServicesLibBundle
{
    static NSBundle *libBundle = nil;
    if (libBundle == nil) {
        // 曲线救国，解决pod中无法加载bundle中的图片问题
        NSBundle *bundle = [NSBundle bundleForClass:[SqliteDatabase class]];
        libBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"BasicServicesLib" ofType:@"bundle"]];
    }
    return libBundle;
}

@end
