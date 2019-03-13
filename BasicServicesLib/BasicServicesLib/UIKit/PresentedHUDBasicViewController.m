//
//  PresentedHUDBasicViewController.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/13.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "PresentedHUDBasicViewController.h"

@interface PresentedHUDBasicViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property(assign, nonatomic) BOOL presenting;

@end

@implementation PresentedHUDBasicViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.animationDuration = 0.25f;
}

- (void)presentView:(UIView *)toView animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [self willPresentInView:toView duration:duration];
    [UIView animateWithDuration:duration animations:^{
        toView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)dismissView:(UIView *)fromView animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [self willDismissFromView:fromView duration:duration];
    [UIView animateWithDuration:duration animations:^{
        fromView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)willPresentInView:(UIView *)toView duration:(NSTimeInterval)duration {}

- (void)willDismissFromView:(UIView *)fromView duration:(NSTimeInterval)duration {}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    if (self.presenting)
    {
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        toView.frame = [UIScreen mainScreen].bounds;
        [containerView addSubview:toView];
        toView.backgroundColor = [UIColor clearColor];
        [self presentView:toView animateTransition:transitionContext];
    }
    else
    {
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        [self dismissView:fromView animateTransition:transitionContext];
    }
}
@end
