//
//  NSString+Size.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/1.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

- (CGSize)boundingSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
