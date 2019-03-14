//
//  UIAlertController+Shortcut.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UIAlertControllerActionHandler)(UIAlertActionStyle style, NSInteger index);

@interface UIAlertController (Shortcut)

+ (UIAlertController *)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionHandler:(UIAlertControllerActionHandler)handler destructiveStyleButtonTitle:(nullable NSString *)destructiveTitle cancelStyleButtonTitle:(nullable NSString *)cancelTitle defaultStyleButtonTitles:(nullable NSString *)defaultTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionHandler:(UIAlertControllerActionHandler)handler destructiveStyleButtonTitle:(nullable NSString *)destructiveTitle cancelStyleButtonTitle:(nullable NSString *)cancelTitle defaultStyleButtonTitles:(nullable NSString *)defaultTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
