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
