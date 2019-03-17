//
//  UIView+NoDatasource.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/4.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 通常情况下，只有UIViewController的view和列表等视图才需要使用

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NoDatasourceType) {
    NoDatasourceTypeEmpty,
    NoDatasourceTypeError
};

@interface UIView (NoDatasource)

- (void)setMessage:(NSString *)message type:(NoDatasourceType)type;
- (void)setHiddenNoDatasource;
- (void)setRetryBlockIfNeeded:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
