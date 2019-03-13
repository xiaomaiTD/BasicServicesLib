//
//  NSDictionary+KeyValueAddition.h
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
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
