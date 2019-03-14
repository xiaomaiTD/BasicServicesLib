//
//  NSString+UIColor.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UIColor)

/// 十六进制的字符串转成UIColor对象
- (UIColor *)color;
- (UIColor *)colorWithAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
