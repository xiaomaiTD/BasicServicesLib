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

#import "YSChainAnimator.h"

@implementation YSChainAnimator

- (instancetype)initWithLayer:(CALayer *)layer
{
    if (self = [super init])
    {
        _layer = layer;
        _animations = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithLayer:view.layer];
}

#pragma mark - Private methods

- (NSString *)_animationKeyWithString:(NSString *)string
{
    if (string) {
        return  string;
    }
    
    return [NSString stringWithFormat:@"com.YSChainAnimator.anim.count_%ld", _animations.count];
}

- (YSChainAnimator *)_addAnimationWithKey:(NSString *)key handler:(CAAnimation * (^) (void))handler
{
    [_animations addObject:@{@"key": [self _animationKeyWithString:key], @"anim":handler()}];
    return self;
}

#pragma mark - Public methods

- (YSChainAnimator * (^)(NSString *, NSString *))anim
{
    if (!_anim)
    {
        __weak __typeof(self)weakSelf = self;
        _anim = ^ YSChainAnimator * (NSString *key, NSString *keyPath) {
            [weakSelf _addAnimationWithKey:key handler:^CAAnimation *{
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keyPath];
                anim.duration = 1.0;
                return anim;
            }];
            return weakSelf;
        };
    }
    return _anim;
}

- (YSChainAnimator * (^)(void (^)(CAAnimation *)))modify
{
    if (!_modify)
    {
        __weak __typeof(self)weakSelf = self;
        _modify = ^ YSChainAnimator * (void (^block) (CAAnimation *)) {
            if (block) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary *animStoreDic = strongSelf->_animations.lastObject;
                CAAnimation *anim = animStoreDic[@"anim"];
                block(anim);
            }
            return weakSelf;
        };
    }
    return _modify;
}

- (YSChainAnimator * (^)(void))group
{
    if (!_group)
    {
        __weak __typeof(self)weakSelf = self;
        _group = ^ YSChainAnimator * (void) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf->_animations.count > 0)
            {
                NSMutableArray *tempAnimations = [NSMutableArray arrayWithCapacity:strongSelf->_animations.count];
                
                for (int i = 0; i < strongSelf->_animations.count; ++i)
                {
                    NSDictionary *animStoreDic = strongSelf->_animations[i];
                    CAAnimation *anim = animStoreDic[@"anim"];
                    [tempAnimations addObject:anim];
                }
                
                [strongSelf->_animations removeAllObjects];
                NSString *key = [NSString stringWithFormat:@"com.YSChainAnimator.anim.group.count_%ld", strongSelf->_animations.count];
                [weakSelf _addAnimationWithKey:key handler:^CAAnimation *{
                    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
                    group.animations = tempAnimations;
                    return group;
                }];
            }
            return weakSelf;
        };
    }
    return _group;
}

- (void (^)(void))run
{
    if (!_run)
    {
        __weak __typeof(self)weakSelf = self;
        _run = ^ {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            for (int i = 0; i < strongSelf->_animations.count; ++i) {
                NSDictionary *animStoreDic = strongSelf->_animations[i];
                CAAnimation *anim = animStoreDic[@"anim"];
                NSString *key = animStoreDic[@"key"];
                [strongSelf->_layer addAnimation:anim forKey:key];
            }
            [strongSelf->_animations removeAllObjects];
        };
    }
    return _run;
}

#pragma mark - Sepecial methods

- (YSChainAnimator * (^)(NSTimeInterval))duration
{
    if (!_duration)
    {
        __weak __typeof(self)weakSelf = self;
        _duration = ^ YSChainAnimator * (NSTimeInterval d) {
            weakSelf.modify(^(CAAnimation *anim) {
                anim.duration = d;
            });
            return weakSelf;
        };
    }
    return _duration;
}

- (YSChainAnimator * (^)(id))from
{
    if (!_from)
    {
        __weak __typeof(self)weakSelf = self;
        _from = ^ YSChainAnimator * (id v) {
            weakSelf.modify(^(CAAnimation *anim) {
                if ([anim isKindOfClass:CABasicAnimation.class]) {
                    [(CABasicAnimation *)anim setFromValue:v];
                }
            });
            return weakSelf;
        };
    }
    return _from;
}

- (YSChainAnimator * (^)(id))to
{
    if (!_to)
    {
        __weak __typeof(self)weakSelf = self;
        _to = ^ YSChainAnimator * (id v) {
            weakSelf.modify(^(CAAnimation *anim) {
                if ([anim isKindOfClass:CABasicAnimation.class]) {
                    [(CABasicAnimation *)anim setToValue:v];
                }
            });
            return weakSelf;
        };
    }
    return _to;
}

- (YSChainAnimator * (^)(id))by
{
    if (!_by)
    {
        __weak __typeof(self)weakSelf = self;
        _by = ^ YSChainAnimator * (id v) {
            weakSelf.modify(^(CAAnimation *anim) {
                if ([anim isKindOfClass:CABasicAnimation.class]) {
                    [(CABasicAnimation *)anim setByValue:v];
                }
            });
            return weakSelf;
        };
    }
    return _by;
}

- (YSChainAnimator * (^)(CAMediaTimingFunction *))timing
{
    if (!_timing)
    {
        __weak __typeof(self)weakSelf = self;
        _timing = ^ YSChainAnimator * (CAMediaTimingFunction *v) {
            weakSelf.modify(^(CAAnimation *anim) {
                if ([anim isKindOfClass:CABasicAnimation.class]) {
                    [(CABasicAnimation *)anim setTimingFunction:v];
                }
            });
            return weakSelf;
        };
    }
    return _timing;
}

- (YSChainAnimator * (^)(void))hold
{
    if (!_hold)
    {
        __weak __typeof(self)weakSelf = self;
        _hold = ^ YSChainAnimator * (void) {
            weakSelf.modify(^(CAAnimation *anim) {
                anim.fillMode = kCAFillModeForwards;
                anim.removedOnCompletion = false;
            });
            return weakSelf;
        };
    }
    return _hold;
}

@end
