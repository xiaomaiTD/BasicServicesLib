//
//  NSDictionary+KeyValueAddition.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "NSDictionary+KeyValueAddition.h"
#import "Macros.h"

@implementation NSDictionary (KeyValueAddition)

static NSRange range_ofArrayCoding(NSString *key)
{
    NSString *arrayCoding = @"\\[\\d\\]$";
    NSRange range = [key rangeOfString:arrayCoding
                               options:NSRegularExpressionSearch];
    return range;
}


- (id)safetyValueForKeyAddition:(NSString *)keyAddition
{
    if (keyAddition.length <= 0 || keyAddition == nil)
    {
        DEV_LOG(@"在调用'safetyValueForKeyAddition:'方法时发生错误：传入的取值路径%@不合法。", keyAddition);
        return nil;
    }
    
    if (![self isKindOfClass:NSDictionary.class])
    {
        DEV_LOG(@"在调用'safetyValueForKeyAddition:'方法时发生错误：目标对象并不是'NSDictionary/NSMutableDictionary'类型。");
        return nil;
    }
    
    NSMutableArray *keys = [[keyAddition componentsSeparatedByString:@"."] mutableCopy];
    NSString *key = keys[0];
    id value = nil;
    
    NSRange arrayCodingRange = range_ofArrayCoding(key);
    // key的实体是数组
    if (arrayCodingRange.location != NSNotFound)
    {
        NSString *indexString = [key substringWithRange:NSMakeRange(arrayCodingRange.location+1, arrayCodingRange.length-2)];
        NSInteger targetIndex = 0;
        if (indexString != nil && indexString.length > 0) {
            targetIndex = [indexString integerValue];
        }
        key = [key substringWithRange:NSMakeRange(0, arrayCodingRange.location)];
        value = [self valueForKey:key];
        
        if (![value isKindOfClass:NSArray.class])
        {
            DEV_LOG(@"在调用'safetyValueForKeyAddition:'方法时发生错误：在取到%@的值时，发现该值的类型不能满足后续取值规范，该值得类型为%@，请检查数据类型是否满足要求。", key, NSStringFromClass([value class]));
            return nil;
        }
        else
        {
            
#undef      Array
#define     Array ((NSArray *)value)
            
            if (Array.count <= targetIndex || Array.count == NSNotFound)
            {
                DEV_LOG(@"在调用'safetyValueForKeyAddition:'方法时发生错误：在取%@所对应的数组的%ld下标对象时，数组下标越界。", key, (long)targetIndex);
                return nil;
            }
            else
            {
                value = [Array objectAtIndex:targetIndex];
            }
        }
    }
    else
    {
        value = [self valueForKey:key];
    }
    
    if (keys.count == 1) {
        return value;
    }
    else
    {
        if (![value isKindOfClass:NSDictionary.class]) {
            DEV_LOG(@"在调用'safetyValueForKeyAddition:'方法时发生错误：在取到%@的值时，发现该值的类型不能满足后续取值规范，该值得类型为%@，请检查数据类型是否满足要求。", key, NSStringFromClass([value class]));
            return nil;
        }
        else
        {
            
#undef      Dictionary
#define     Dictionary ((NSDictionary *)value)
            
            [keys removeObjectAtIndex:0];
            NSString *subKeyAddtion = [keys componentsJoinedByString:@"."];
            return [Dictionary safetyValueForKeyAddition:subKeyAddtion];
        }
    }
}

- (NSDictionary *)safetySetValue:(id)value forKeyAddition:(NSString *)keyAddition
{
    if (keyAddition.length <= 0 || keyAddition == nil)
    {
        DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：传入的设值路径%@不合法。", keyAddition);
        return self;
    }
    
    if (value == nil)
    {
        DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：需要设置的value为nil。");
        return self;
    }
    
    if (![self isKindOfClass:NSDictionary.class])
    {
        DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：目标对象并不是'NSDictionary/NSMutableDictionary'类型。");
        return self;
    }
    
    NSMutableArray *keys = [[keyAddition componentsSeparatedByString:@"."] mutableCopy];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self];
    NSString *key = keys[0];
    BOOL isOnlyElement = keys.count == 1;
    
    NSRange arrayCodingRange = range_ofArrayCoding(key);
    if (arrayCodingRange.location != NSNotFound)
    {
        NSString *indexString = [key substringWithRange:NSMakeRange(arrayCodingRange.location+1, arrayCodingRange.length-2)];
        NSInteger targetIndex = 0;
        if (indexString != nil && indexString.length > 0) {
            targetIndex = [indexString integerValue];
        }
        key = [key substringWithRange:NSMakeRange(0, arrayCodingRange.location)];
        
        id array = [mDict objectForKey:key];
        if (array != nil && ![array isKindOfClass:NSArray.class]) {
            DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：在取到%@的值时，发现该值的类型不能满足后续取值规范，该值得类型为%@，请检查数据类型是否满足要求。", key, NSStringFromClass([value class]));
        }
        else
        {
            
#undef      Array
#define     Array (((NSArray *)array) != nil ? ((NSArray *)array) : NSArray.array)
            
            if (Array.count <= targetIndex || Array.count == NSNotFound) {
                DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：在取%@所对应的数组的%ld下标对象时，数组下标越界。", key, (long)targetIndex);
            }
            else
            {
                if (isOnlyElement)
                {
                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:Array];
                    [mArray replaceObjectAtIndex:targetIndex withObject:value];
                    [mDict setValue:[mArray copy] forKey:key];
                    return [mDict copy];
                }
                else
                {
                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:Array];
                    id subDict = [mArray objectAtIndex:targetIndex];
                    if (subDict != nil && ![subDict isKindOfClass:NSDictionary.class]) {
                        DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：在取到%@的值时，发现该值的类型不能满足后续取值规范，该值得类型为%@，请检查数据类型是否满足要求。", key, NSStringFromClass([subDict class]));
                    }
                    else
                    {
                        
#undef                  Dictionary
#define                 Dictionary (((NSDictionary *)subDict) != nil ? ((NSDictionary *)subDict) : NSDictionary.dictionary)
                        
                        NSMutableArray *_keys = [NSMutableArray arrayWithArray:keys];
                        [_keys removeObjectAtIndex:0];
                        NSString *subKeyAddition = [_keys componentsJoinedByString:@"."];
                        [mDict setValue:[Dictionary safetySetValue:value forKeyAddition:subKeyAddition] forKey:key];
                    }
                }
            }
        }
    }
    else
    {
        if (isOnlyElement) {
            [mDict setValue:value forKey:key];
        }
        else
        {
            id subDict = [mDict objectForKey:key];
            if (subDict != nil && ![subDict isKindOfClass:NSDictionary.class]) {
                DEV_LOG(@"在调用'safetySetValue:forKeyAddition:'方法时发生错误：在取到%@的值时，发现该值的类型不能满足后续取值规范，该值得类型为%@，请检查数据类型是否满足要求。", key, NSStringFromClass([subDict class]));
            }
            else
            {
                
#undef          Dictionary
#define         Dictionary (((NSDictionary *)subDict) != nil ? ((NSDictionary *)subDict) : NSDictionary.dictionary)
                
                NSMutableArray *_keys = [NSMutableArray arrayWithArray:keys];
                [_keys removeObjectAtIndex:0];
                NSString *subKeyAddition = [_keys componentsJoinedByString:@"."];
                [mDict setValue:[Dictionary safetySetValue:value forKeyAddition:subKeyAddition] forKey:key];
            }
        }
    }
    
    return [mDict copy];
}

@end
