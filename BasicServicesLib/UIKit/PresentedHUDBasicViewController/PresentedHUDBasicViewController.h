//
//  PresentedHUDBasicViewController.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/13.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresentedHUDBasicViewController : UIViewController

/// Animation time for view switching. Defaults to 0.25 seconds.
@property(assign, nonatomic) NSTimeInterval animationDuration;

/*
 * Rewrite the following methods to implement the animation of the custom pop-up box.
 */

/// Rewrite the following methods to achieve the animation of the pop-up box.
- (void)willPresentInView:(UIView *)toView duration:(NSTimeInterval)duration;
/// Rewrite the following methods to achieve the animation of the pop up box.
- (void)willDismissFromView:(UIView *)fromView duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
