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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define YSChainAnimator(layer)  [[YSChainAnimator alloc] initWithLayer:layer]

typedef NSMutableArray<NSDictionary*> * YSChainAnimatorContainer;

@interface YSChainAnimator : NSObject {
    __weak CALayer *_layer;
    YSChainAnimatorContainer _animations;
}

- (instancetype)initWithLayer:(CALayer * _Nonnull)layer;
- (instancetype)initWithView:(UIView * _Nonnull)view;

@property(copy, nonatomic) YSChainAnimator * (^anim) (NSString * _Nullable key, NSString * _Nonnull keyPath);
@property(copy, nonatomic) YSChainAnimator * (^modify) (void (^ _Nonnull) (CAAnimation * _Nonnull anim));
@property(copy, nonatomic) YSChainAnimator * (^group) (void);
@property(copy, nonatomic) void (^run) (void);

@property(copy, nonatomic) YSChainAnimator * (^duration) (NSTimeInterval d);
@property(copy, nonatomic) YSChainAnimator * (^from) (id v);
@property(copy, nonatomic) YSChainAnimator * (^to) (id v);
@property(copy, nonatomic) YSChainAnimator * (^by) (id v);
@property(copy, nonatomic) YSChainAnimator * (^timing) (CAMediaTimingFunction *v);
@property(copy, nonatomic) YSChainAnimator * (^hold) (void);

@end

NS_ASSUME_NONNULL_END

        
