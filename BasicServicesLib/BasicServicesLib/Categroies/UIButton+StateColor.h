//
//  UIButton+StateColor.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (StateColor)

/// colors[0] = normal
/// colors[1] = highlighted
/// colors[2] = disabled
- (void)setBackgroundImageWithColors:(NSArray<UIColor*> *)colors;
- (void)setTitleColorWithColors:(NSArray<UIColor*> *)colors;


@end

NS_ASSUME_NONNULL_END
