//
//  UIRelayoutButton.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/13.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIRelayoutButtonStyle) {
    // image在上，label在下
    UIRelayoutButtonStyleTop,
    // image在左，label在右
    UIRelayoutButtonStyleLeft,
    // image在下，label在上
    UIRelayoutButtonStyleBottom,
    // image在右，label在左
    UIRelayoutButtonStyleRight
};

/// 默认为 UIRelayoutButtonStyleTop
@interface UIRelayoutButton : UIButton

///方法仅适用于固定按钮的调整图片和文字的位置使用。应该在设置完文字和图片后在调用。
- (void)setRelayoutButtonStyle:(UIRelayoutButtonStyle)style spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
