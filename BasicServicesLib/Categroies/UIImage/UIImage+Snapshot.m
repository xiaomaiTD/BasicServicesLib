//
//  UIImage+Snapshot.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "UIImage+Snapshot.h"

@implementation UIImage (Snapshot)

+ (UIImage *)snapImageFromView:(UIView * _Nonnull)aView
{
    return [self snapImageFromView:aView size:aView.bounds.size];
}

+ (UIImage *)snapImageFromView:(UIView * _Nonnull)aView size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
