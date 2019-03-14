//
//  SqliteDatabase.h
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/5.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 数据表的设计很简单，将整体转成json存储，json使用AES加密。
 * 注意：所有的insert都是如果存在就更新，不存在就插入。
 */

NS_ASSUME_NONNULL_BEGIN

extern double const kBytesToMbDivisor;

typedef NSArray<NSDictionary *> * SqliteItems;

@interface SqliteDatabase : NSObject

+ (NSString *)databaseNamed;
+ (instancetype)database;

- (NSString *)dbPath;
- (NSInteger)bytes;
- (NSArray *)tables;
- (void)clear;

/// 单据详情使用，primery表示在字典中取那个字段的值作为表的主键
- (void)insertItem:(nonnull NSDictionary *)item primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (void)removeItem:(nonnull NSDictionary *)item primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (void)updateItem:(nonnull NSDictionary *)item primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (NSDictionary *)getItemWithPrimeryValue:(NSString *)value inTable:(NSString *)table;

/// 列表使用，primery表示在字典中取那个字段的值作为表的主键
- (void)insertItems:(SqliteItems)items primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (void)removeItems:(SqliteItems)items primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (void)updateItems:(SqliteItems)items primeryPath:(nonnull NSString *)primery inTable:(nonnull NSString *)table;
- (SqliteItems)getItemsInTable:(NSString *)table size:(NSInteger)size page:(NSInteger)page;

/// 登录信息
- (void)insertLoginWithAccount:(NSString *)account password:(NSString *)psd;
- (void)removeLoginWithAccount:(NSString *)account;
- (NSString *)getPasswordByAccount:(NSString *)account;
- (NSArray<NSDictionary *> *)getAllLoginAccount;

/// 用户信息
- (void)insertUserInfo:(NSDictionary *)dict forAccount:(NSString *)account;
- (void)removeUserInfoWithAccount:(NSString *)account;
- (NSDictionary * _Nullable)getUserInfoByAccount:(NSString *)account;
- (NSArray<NSDictionary *> *)getAllUserInfos;

@end

NS_ASSUME_NONNULL_END
