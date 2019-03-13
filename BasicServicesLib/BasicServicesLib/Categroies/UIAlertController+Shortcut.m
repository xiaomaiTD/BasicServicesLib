//
//  UIAlertController+Shortcut.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UIAlertController+Shortcut.h"

@implementation UIAlertController (Shortcut)

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message actionHandler:(UIAlertControllerActionHandler)handler destructiveStyleButtonTitle:(NSString *)destructiveTitle cancelStyleButtonTitle:(NSString *)cancelTitle defaultStyleButtonTitles:(NSString *)defaultTitles, ...
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title  message:message preferredStyle:UIAlertControllerStyleAlert];
    if (destructiveTitle)
    {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleDestructive, 0);
            }
        }];
        [alertController addAction:destructiveAction];
    }
    
    if (cancelTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleCancel, 0);
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    if (defaultTitles)
    {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleDefault, 0);
            }
        }];
        [alertController addAction:defaultAction];
        
        va_list args;
        NSString *arg;
        va_start(args, defaultTitles);
        NSInteger index = 1;
        while ((arg = va_arg(args, NSString *)))
        {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(UIAlertActionStyleDefault, index);
                }
            }];
            [alertController addAction:defaultAction];
            index ++;
        }
        va_end(args);
    }
    
    return alertController;
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message actionHandler:(UIAlertControllerActionHandler)handler destructiveStyleButtonTitle:(NSString *)destructiveTitle cancelStyleButtonTitle:(NSString *)cancelTitle defaultStyleButtonTitles:(NSString *)defaultTitles, ...
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (destructiveTitle)
    {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleDestructive, 0);
            }
        }];
        [alertController addAction:destructiveAction];
    }
    
    if (cancelTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleCancel, 0);
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    if (defaultTitles)
    {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(UIAlertActionStyleDefault, 0);
            }
        }];
        [alertController addAction:defaultAction];
        
        va_list args;
        NSString *arg;
        va_start(args, defaultTitles);
        NSInteger index = 1;
        while ((arg = va_arg(args, NSString *)))
        {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(UIAlertActionStyleDefault, 0);
                }
            }];
            [alertController addAction:defaultAction];
            index ++;
        }
        va_end(args);
    }
    
    return alertController;
}

@end
