//
//  NSBundle+BasicServicesLibResource.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
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
