//
//  UIView+CGRect.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CGRect)

@property(assign, nonatomic) CGPoint origin;
@property(assign, nonatomic) CGFloat left;
@property(assign, nonatomic) CGFloat top;
@property(assign, nonatomic) CGFloat right;
@property(assign, nonatomic) CGFloat bottom;
@property(assign, nonatomic) CGFloat width;
@property(assign, nonatomic) CGFloat height;

@end

NS_ASSUME_NONNULL_END
