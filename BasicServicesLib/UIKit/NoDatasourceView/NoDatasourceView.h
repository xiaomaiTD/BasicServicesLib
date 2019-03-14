//
//  NoDatasourceView.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/4.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoDatasourceView : UIView

+ (instancetype)showInView:(nonnull UIView *)aView;

- (void)setImage:(nonnull UIImage *)image;
- (void)setMessage:(nonnull NSString *)message;
- (void)setRetryText:(nonnull NSString *)text;

- (void)setRetryAction:(dispatch_block_t)action;

@end

NS_ASSUME_NONNULL_END
