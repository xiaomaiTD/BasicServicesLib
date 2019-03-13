//
//  UIWindow+TransitionRootVc.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/3/2.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "UIWindow+TransitionRootVc.h"

@implementation UIWindow (TransitionRootVc)

- (void)transitionRootVc:(UIViewController *)rootVc duration:(NSTimeInterval)duration options:(UIWindowTransitionRootAnimationOption)options completion:(void (^)(BOOL))completion
{
    [UIView transitionWithView:self duration:duration options:(UIViewAnimationOptions)options animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        self.rootViewController = rootVc;
        [UIView setAnimationsEnabled:oldState];
    } completion:completion];
}

@end
