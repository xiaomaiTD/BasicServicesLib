//
//  UITextField+Placeholder.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* NSTextFieldPlacholderKeypath;
UIKIT_EXTERN NSTextFieldPlacholderKeypath const kTextFieldPlaceholderKeypathColorName;
UIKIT_EXTERN NSTextFieldPlacholderKeypath const kTextFieldPlaceholderKeypathFontName;

@interface UITextField (Placeholder)

- (void)setPlaceholderColor:(nonnull UIColor *)aColor;
- (void)setPlaceholderFont:(nonnull UIFont *)aFont;

@end

NS_ASSUME_NONNULL_END
