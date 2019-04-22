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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NSNotificationCenterResponder) (id sender);

@interface NSNotificationCenter (ObserverBlocked)

/**
 * 由于通知中心是一个单利对象，如果采用和KVO相同的思路实现block替换的话会造成移除block时将不需要移除的也一并移除掉。
 * 目前的解决办法是给该block添加一个唯一键值(identifier)。
 * block使用时，请注意循环引用。
 * 其他办法呢？
 */
- (void)addBlockWithName:(NSNotificationName _Nonnull)aName object:(id _Nullable)anObject identifier:(NSString * _Nonnull)identifier responder:(NSNotificationCenterResponder _Nonnull)responder;

/**
 * 添加后一定要在delloc中移除。
 */
- (void)removeBlockWithName:(NSNotificationName _Nonnull)aName identifier:(NSString * _Nonnull)identifier;

@end

NS_ASSUME_NONNULL_END
