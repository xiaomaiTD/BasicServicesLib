//
//  NSBundle+BasicServicesLibResource.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "NSBundle+BasicServicesLibResource.h"

@implementation NSBundle (BasicServicesLibResource)

+ (instancetype)basicServicesLibBundle
{
    static NSBundle *libBundle = nil;
    if (libBundle == nil) {
        libBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BasicServicesLib" ofType:@"bundle"]];
    }
    return libBundle;
}

@end
