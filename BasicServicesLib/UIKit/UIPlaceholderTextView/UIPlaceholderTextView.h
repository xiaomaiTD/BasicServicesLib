//
//  UIPlaceholderTextView.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/13.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPlaceholderTextView : UITextView

/// 目前占位符只支持一排文字。
@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
