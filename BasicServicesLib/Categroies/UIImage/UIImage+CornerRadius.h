//
//  UIImage+CornerRadius.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/21.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CornerRadius)

- (UIImage *)cropedImageWithCornerRaidus:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
