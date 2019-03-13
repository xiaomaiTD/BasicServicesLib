//
//  UIWindow+TransitionRootVc.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, UIWindowTransitionRootAnimationOption) {
    UIWindowTransitionRootAnimationOptionNode                   = 0 << 20, // default
    UIWindowTransitionRootAnimationOptionFlipFromLeft           = 1 << 20,
    UIWindowTransitionRootAnimationOptionFlipFromRight          = 2 << 20,
    UIWindowTransitionRootAnimationOptionCurlUp                 = 3 << 20,
    UIWindowTransitionRootAnimationOptionCurlDown               = 4 << 20,
    UIWindowTransitionRootAnimationOptionCrossDissolve          = 5 << 20,
    UIWindowTransitionRootAnimationOptionFlipFromTop            = 6 << 20,
    UIWindowTransitionRootAnimationOptionFlipFromBottom         = 7 << 20
};

@interface UIWindow (TransitionRootVc)

- (void)transitionRootVc:(nonnull UIViewController *)rootVc duration:(NSTimeInterval)duration options:(UIWindowTransitionRootAnimationOption)options completion:(void (^) (BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
