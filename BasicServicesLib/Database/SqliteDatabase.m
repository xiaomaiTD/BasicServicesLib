//
//  SqliteDatabase.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/5.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "SqliteDatabase.h"
#import <FMDB/FMDB.h>
#import "Macros.h"
#import "NSString+Encrypt.h"
#import "NSDictionary+KeyValueAddition.h"

double const kBytesToMbDivisor = 1024 * 1024;

static NSString * const kAESIv = @"Luckeyhill_Luckeyhill";
static NSString * const kAESKey = @"basicserviceslib";

static NSString * const kUserTableName = @"user_table";
static NSString * const kUserLoginTableName = @"user_login_table";

static NSString *convert_toString(NSDictionary *dict)
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        DEV_LOG(@"%@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = { 0, jsonString.length };
    // 去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = { 0, mutStr.length };
    // 去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return [mutStr copy];
}

static NSDictionary *convert_toDictionary(NSString *json)
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return tempDictQueryDiamond;
}

static NSData *aes_iv(void)
{
    return [kAESIv dataUsingEncoding:NSUTF8StringEncoding];
}

@interface SqliteDatabase ()

@property(strong, nonatomic) FMDatabaseQueue *queue;
@property(strong, nonatomic) __block NSMutableSet *tableSet;

@end

@implementation SqliteDatabase

+ (NSString *)databaseNamed
{
    static NSString *named = nil;
    if (named == nil) {
        named = [app_named() stringByAppendingString:@".sqlite"];
    }
    return named;
}

+ (instancetype)database
{
    static SqliteDatabase *sqliteDB = nil;
    if (sqliteDB == nil) {
        sqliteDB = [[SqliteDatabase alloc] init];
    }
    return sqliteDB;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _tableSet = [NSMutableSet set];
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:[self.class databaseNamed]];
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (NSString *)dbPath
{
    return _queue.path;
}

- (NSUInteger)bytes
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self dbPath]]) {
        return [[manager attributesOfItemAtPath:[self dbPath] error:nil] fileSize];
    }
    return 0;
}

- (NSArray *)tables
{
    return self.tableSet.allObjects;
}

- (void)clear
{
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try
        {
            for (NSString *table in [weakSelf tables])
            {
                NSString *dropTableSql = NSStringFormat(@"DROP TABLE %@", table);
                [db executeUpdate:dropTableSql];
            }
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [db rollback];
        }
        @finally
        {
            if (!isRollBack) {
                [db commit];
            }
        }
        
        [db executeUpdate:@"VACUUM"];
        
        [db close];
    }];
}

- (void)insertItem:(NSDictionary *)item primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (item == nil || primery == nil || table == nil) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *createTableSql = NSStringFormat(@"CREATE TABLE IF NOT EXISTS '%@' ('_primery' TEXT PRIMARY KEY NOT NULL, '_value' TEXT NOT NULL)", table);
        if (![db executeUpdate:createTableSql])
        {
            [db close];
            return;
        }
        [weakSelf.tableSet addObject:table];
        
        NSString *insertItesSql = NSStringFormat(@"REPLACE INTO '%@' (_primery,_value) VALUES(?,?)", table);
        NSString *_primery = [item safetyValueForKeyAddition:primery];
        NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *json = convert_toString(item);
        NSString *jsonEncrypted = [json encryptedWithAESUsing:kAESKey iv:aes_iv()];
        [db executeUpdate:insertItesSql withArgumentsInArray:@[_primeyEncrypted, jsonEncrypted]];
        
        [db close];
    }];
}

- (void)removeItem:(NSDictionary *)item primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (item == nil || primery == nil || table == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *_primery = [item safetyValueForKeyAddition:primery];
        NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *deleteItemSql = NSStringFormat(@"DELETE FROM '%@' WHERE _primery = '%@'", table, _primeyEncrypted);
        [db executeUpdate:deleteItemSql];
        
        [db close];
    }];
}

- (void)updateItem:(NSDictionary *)item primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (item == nil || primery == nil || table == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *_primery = [item safetyValueForKeyAddition:primery];
        NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *deleteItemSql = NSStringFormat(@"UPDATE FROM '%@' WHERE _primery = '%@'", table, _primeyEncrypted);
        [db executeUpdate:deleteItemSql];
        
        [db close];
    }];
}

- (NSDictionary *)getItemWithPrimeryValue:(NSString *)value inTable:(NSString *)table
{
    if (value == nil || table == nil) {
        return nil;
    }
    
    __block NSDictionary *dict = nil;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
    
        NSString *_primeyEncrypted = [value encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *queryItemSql = NSStringFormat(@"SELECT * FROM %@ WHERE _primery = '%@'", table, _primeyEncrypted);
        FMResultSet *result = [db executeQuery:queryItemSql];
        while ([result next])
        {
            NSString *jsonEncrypte = result.resultDictionary[@"_value"];
            NSString *json = [jsonEncrypte decryptedWithAESUsing:kAESIv iv:aes_iv()];
            dict = convert_toDictionary(json);
        }
        
        [result close];
        [db close];
    }];
    
    return dict;
}

- (void)insertItems:(SqliteItems)items primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (items.count <= 0 || primery == nil || table == nil) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *createTableSql = NSStringFormat(@"CREATE TABLE IF NOT EXISTS '%@' ('_primery' TEXT PRIMARY KEY NOT NULL, '_value' TEXT NOT NULL, '_date' TimeStamp NOT NULL DEFAULT CURRENT_TIMESTAMP)", table);
        if (![db executeUpdate:createTableSql])
        {
            [db close];
            return;
        }
        [weakSelf.tableSet addObject:table];
        
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try
        {
            NSString *insertItesSql = NSStringFormat(@"REPLACE INTO '%@' (_primery,_value) VALUES(?,?)", table);
            for (NSDictionary *dict in items)
            {
                NSString *_primery = [dict safetyValueForKeyAddition:primery];
                NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
                NSString *json = convert_toString(dict);
                NSString *jsonEncrypted = [json encryptedWithAESUsing:kAESKey iv:aes_iv()];
                [db executeUpdate:insertItesSql withArgumentsInArray:@[_primeyEncrypted, jsonEncrypted]];
            }
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [db rollback];
        }
        @finally
        {
            if (!isRollBack) {
                [db commit];
            }
        }
        
        [db close];
    }];
}

- (void)removeItems:(SqliteItems)items primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (items.count <= 0 || primery == nil || table == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try
        {
            for (NSInteger idx = 0; idx < items.count; ++ idx)
            {
                NSDictionary *dict = items[idx];
                NSString *_primery = [dict safetyValueForKeyAddition:primery];
                NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
                NSString *deleteItemSql = NSStringFormat(@"DELETE FROM '%@' WHERE _primery = '%@'", table, _primeyEncrypted);
                [db executeUpdate:deleteItemSql];
            }
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [db rollback];
        }
        @finally
        {
            if (!isRollBack) {
                [db commit];
            }
        }
        
        [db close];
    }];
}

- (void)updateItems:(SqliteItems)items primeryPath:(NSString *)primery inTable:(NSString *)table
{
    if (items.count <= 0 || primery == nil || table == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try
        {
            for (NSInteger idx = 0; idx < items.count; ++ idx)
            {
                NSDictionary *dict = items[idx];
                NSString *_primery = [dict safetyValueForKeyAddition:primery];
                NSString *_primeyEncrypted = [_primery encryptedWithAESUsing:kAESKey iv:aes_iv()];
                NSString *json = convert_toString(dict);
                NSString *jsonEncrypted = [json encryptedWithAESUsing:kAESKey iv:aes_iv()];
                NSString *updateItemSql = NSStringFormat(@"UPDATE '%@' SET _value = '%@' , _date = CURRENT_TIMESTAMP WHERE _primery = '%@'", table, jsonEncrypted, _primeyEncrypted);
                [db executeUpdate:updateItemSql];
            }
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [db rollback];
        }
        @finally
        {
            if (!isRollBack) {
                [db commit];
            }
        }
        
        [db close];
    }];
}

- (SqliteItems)getItemsInTable:(NSString *)table size:(NSUInteger)size page:(NSUInteger)page
{
    if (table == nil || size == 0) {
        return nil;
    }
    
    __block NSMutableArray *list = NSMutableArray.array;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try
        {
            NSString *querySql = NSStringFormat(@"SELECT * FROM %@ ORDER BY _date DESC LIMIT %lu OFFSET %lu", table, size, size * page);
            FMResultSet *result = [db executeQuery:querySql];
            
            while ([result next])
            {
                NSString *valueEncrypted = result.resultDictionary[@"_value"];
                NSString *value = [valueEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
                NSDictionary *dict = convert_toDictionary(value);
                [list addObject:dict];
            }
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [db rollback];
        }
        @finally
        {
            if (!isRollBack) {
                [db commit];
            }
        }
        
        [db close];
    }];
    
    return list.count == 0 ? nil : [list copy];
}

- (void)insertLoginWithAccount:(NSString *)account password:(NSString *)psd
{
    if (account == nil || psd == nil) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *createTableSql = NSStringFormat(@"CREATE TABLE IF NOT EXISTS '%@' ('_account' TEXT PRIMARY KEY NOT NULL, '_psd' TEXT NOT NULL, '_isCurrent' BIT NOT NULL)", kUserLoginTableName);
        if (![db executeUpdate:createTableSql])
        {
            [db close];
            return;
        }
        [weakSelf.tableSet addObject:kUserLoginTableName];
        
        NSString *updateCurrentSql = NSStringFormat(@"UPDATE %@ SET _isCurrent = 0", kUserLoginTableName);
        [db executeUpdate:updateCurrentSql];
        
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *psdEncrypted = [psd encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *insertUserSql = NSStringFormat(@"REPLACE INTO '%@'(_account,_psd,_isCurrent) VALUES(?,?,?)", kUserLoginTableName);
        [db executeUpdate:insertUserSql withArgumentsInArray:@[accountEncrypted, psdEncrypted, @1]];
        
        [db close];
    }];
}

- (void)removeLoginWithAccount:(NSString *)account
{
    if (account == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *deleteSql = NSStringFormat(@"DELETE FROM %@ WHERE _account = '%@'", kUserLoginTableName, accountEncrypted);
        [db executeUpdate:deleteSql];
        
        [db close];
    }];
}

- (NSString *)getPasswordByAccount:(NSString *)account
{
    if (account == nil) {
        return nil;
    }
    
    __block NSString *psd = nil;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *querySql = NSStringFormat(@"SELECT * FROM %@ WHERE _account = '%@'", kUserLoginTableName, accountEncrypted);
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            NSString *psdEncrypted = result.resultDictionary[@"_psd"];
            psd = [psdEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
        }
        
        [result close];
        [db close];
    }];
    
    return psd;
}

- (NSArray<NSDictionary *> *)getAllLoginAccount
{
    __block NSMutableArray *logins = NSMutableArray.array;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *querySql = NSStringFormat(@"SELECT * FROM %@", kUserLoginTableName);
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            NSString *accountEncrypted = result.resultDictionary[@"_account"];
            NSString *account = [accountEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
            id isCurrent = result.resultDictionary[@"_isCurrent"];
            [logins addObject:@{@"account":account, @"isCurrent":isCurrent}];
        }
        
        [result close];
        [db close];
    }];
    
    return logins.count == 0 ? nil : [logins copy];
}

- (void)insertUserInfo:(NSDictionary *)dict forAccount:(NSString *)account
{
    if (dict == nil || account == nil) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return;
        }
        
        NSString *createTableSql = NSStringFormat(@"CREATE TABLE IF NOT EXISTS '%@' ('_account' TEXT PRIMARY KEY NOT NULL, '_info' TEXT NOT NULL)", kUserTableName);
        if (![db executeUpdate:createTableSql])
        {
            [db close];
            return;
        }
        [weakSelf.tableSet addObject:kUserTableName];
        
        NSString *json = convert_toString(dict);
        NSString *jsonEncrypted = [json encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *insertUserSql = NSStringFormat(@"REPLACE INTO '%@'(_account,_info) VALUES(?,?)", kUserTableName);
        [db executeUpdate:insertUserSql withArgumentsInArray:@[accountEncrypted, jsonEncrypted]];
        
        [db close];
    }];
}

- (void)removeUserInfoWithAccount:(NSString *)account
{
    if (account == nil) {
        return;
    }
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *deleteSql = NSStringFormat(@"DELETE FROM %@ WHERE _account = '%@'", kUserTableName, accountEncrypted);
        [db executeUpdate:deleteSql];
        
        [db close];
    }];
}

- (NSDictionary *)getUserInfoByAccount:(NSString *)account
{
    if (account == nil) {
        return nil;
    }
    
    __block NSDictionary *dict = nil;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *accountEncrypted = [account encryptedWithAESUsing:kAESKey iv:aes_iv()];
        NSString *querySql = NSStringFormat(@"SELECT * FROM %@ WHERE _account = '%@'", kUserTableName, accountEncrypted);
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            NSString *jsonEncrypted = result.resultDictionary[@"_info"];
            NSString *json = [jsonEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
            dict = convert_toDictionary(json);
        }
        
        [result close];
        [db close];
    }];
    
    return dict;
}

- (NSArray<NSDictionary *> *)getAllUserInfos
{
    __block NSMutableArray *infos = NSMutableArray.array;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *querySql = NSStringFormat(@"SELECT * FROM %@", kUserTableName);
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            NSString *jsonEncrypted = result.resultDictionary[@"_info"];
            NSString *json = [jsonEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
            NSDictionary *dict = convert_toDictionary(json);
            NSString *accountEncrypted = result.resultDictionary[@"_account"];
            NSString *account = [accountEncrypted decryptedWithAESUsing:kAESKey iv:aes_iv()];
            [infos addObject:@{@"account":account, @"info":dict}];
        }
        
        [result close];
        [db close];
    }];
    
    return infos.count == 0 ? nil : [infos copy];
}

@end
