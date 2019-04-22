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

@interface NSDictionary (KeyValueAddition)

/// 网络请求通常获得的字典都是嵌套的，为了去模型化，我们直接使用字典作为网络数据对象而不再序列化为模型实体。本方法用于根据嵌套地keyAddition取对应的值。
/// 例如：{ data:{name:zhangsan} } ，调用为 [dict safetyValueForKeyAddition:@"data.name"]，将获得'zhangsan'的值。
/// 当然，真实场景中的数据比这个复杂多了，通常还会存在数组的嵌套。这时如果要取数组中的某个实体的语法为@"data.array[1].name"。
- (id)safetyValueForKeyAddition:(NSString *)keyAddition;
- (NSDictionary *)safetySetValue:(id)value forKeyAddition:(NSString *)keyAddition;

@end

NS_ASSUME_NONNULL_END
