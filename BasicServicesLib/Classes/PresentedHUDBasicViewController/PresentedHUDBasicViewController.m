//
//  Copyright © 2019 yeeshe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
