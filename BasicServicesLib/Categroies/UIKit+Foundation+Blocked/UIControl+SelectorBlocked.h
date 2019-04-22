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

// Refer: https://www.jianshu.com/p/ee9756f3d5f6

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIControlResponder) (UIControl * _Nonnull sender);

@interface UIControl (SelectorBlocked)

/**
 * 由于block的原因，使用时需要注意循环引用，特别是使用self这种关键词。
 * 这个方法虽然使用起来方便，但是一定注意其内存管理，多使用weak。
 */
- (void)addBlockForControlEvents:(UIControlEvents)events responder:(UIControlResponder _Nonnull)responder;
- (void)removeBlocksForControlEvents:(UIControlEvents)events;

@end

NS_ASSUME_NONNULL_END
