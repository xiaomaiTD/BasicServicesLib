//
//  Constants.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

CG_INLINE CGRect REct(CGFloat x, CGFloat y, CGFloat w, CGFloat h) { return CGRectMake(x, y, w, h); }
CG_INLINE CGPoint POint(CGFloat x, CGFloat y) { return CGPointMake(x, y); }
CG_INLINE CGSize SIze(CGFloat w, CGFloat h) { return CGSizeMake(w, h); }
CG_INLINE UIEdgeInsets EDges(CGFloat t, CGFloat l, CGFloat b, CGFloat r) { return UIEdgeInsetsMake(t, l, b, r); }

UIKIT_EXTERN NSString *app_named(void);
UIKIT_EXTERN NSString *app_version(void);
UIKIT_EXTERN NSString *app_build(void);

UIKIT_EXTERN CGFloat const kNavigationBarHeight;
UIKIT_EXTERN CGFloat const kToastDefaultDismissDelay;
UIKIT_EXTERN CGFloat const kResultHUDDismissDelay;

