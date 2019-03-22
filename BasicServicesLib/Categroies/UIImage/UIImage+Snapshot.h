//
//  UIImage+Snapshot.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Snapshot)

+ (UIImage *)snapImageFromView:(UIView * _Nonnull)aView;
+ (UIImage *)snapImageFromView:(UIView * _Nonnull)aView size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
