//
//  UIView+UINib.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UINib)

+ (UINib *)loadNib;
+ (UINib *)loadNibNamed:(NSString *)nibName;
+ (UINib *)loadNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle;

+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(nullable id)owner;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(nullable id)owner bundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
