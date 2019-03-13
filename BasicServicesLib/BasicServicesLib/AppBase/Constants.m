//
//  Constants.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "Constants.h"

CGFloat const kNavigationBarHeight = 44.0;
CGFloat const kToastDefaultDismissDelay = 2.3;
CGFloat const kResultHUDDismissDelay = 1.45;

static NSDictionary *project_infoDictionary(void)
{
    static NSDictionary *infoDict = nil;
    if (infoDict == nil)
    {
        infoDict = [NSBundle mainBundle].localizedInfoDictionary;
        if (!infoDict || !infoDict.count) {
            infoDict = [NSBundle mainBundle].infoDictionary;
        }
        
        if (!infoDict || !infoDict.count)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
    return infoDict ? : @{};
}

NSString *app_named(void)
{
    NSDictionary *infoDict = project_infoDictionary();
    NSString *named = [infoDict valueForKey:@"CFBundleDisplayName"];
    if (!named) {
        named = [infoDict valueForKey:@"CFBundleName"];
    }
    return named;
}

NSString *app_version(void)
{
    NSDictionary *infoDict = project_infoDictionary();
    return [infoDict valueForKey:@"CFBundleShortVersionString"];
}

NSString *app_build(void)
{
    NSDictionary *infoDict = project_infoDictionary();
    return [infoDict valueForKey:@"CFBundleVersion"];
}
