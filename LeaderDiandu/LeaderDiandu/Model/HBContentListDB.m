//
//  HBContentListDB.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentListDB.h"
#import "UtilFMDatabase.h"
#import "UtilFMDatabaseQueue.h"
#import "FileUtil.h"
#import "HBContentEntity.h"

//课本信息数据库保存路径
#define HBContentList_DB_FILENAME  @"hbcontentlist.db"

@implementation HBContentListDB

+ (HBContentListDB *)sharedInstance {
    
    static HBContentListDB *_sharedInstance;
    if(!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[HBContentListDB alloc] init];
        });
    }
    
    return _sharedInstance;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    
}

/**
 *  更新套餐信息
 *
 *  @param contentListArr   套餐信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBContentList:(NSArray *)contentListArr
{
    __block BOOL isOK = NO;
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBContentListDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         [db beginTransaction];
         BOOL isRollBack = NO;
         
         @try
         {
             for (NSDictionary *dic in contentListArr) {
                 
                 NSNumber *bookIdNum = [NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]];
                 NSNumber *totalNum = [NSNumber numberWithInteger:[[dic objectForKey:@"total"] integerValue]];
                 NSString *subscribedStr = @"0";
                 NSString *substatusStr = @"0";
                 if ([dic objectForKey:@"subscribed"]) {
                     subscribedStr = @"1";
                 }
                 if ([dic objectForKey:@"substatus"]) {
                     substatusStr = @"1";
                 }
                 
                 BOOL result = [db executeUpdate:@"REPLACE INTO contentList(bookID, total, name, description, books, freeBooks, subscribed, substatus) VALUES(?, ?, ?, ?, ?, ?, ?, ?)",bookIdNum, totalNum, [dic objectForKey:@"name"], [dic objectForKey:@"description"], [dic objectForKey:@"books"], [dic objectForKey:@"free_books"], subscribedStr, substatusStr];
                 
                 if (result == NO) {
                     //save erro!
                 }
             }
         }
         @catch (NSException *exception)
         {
             isRollBack = YES;
             [db rollback];
         }
         @finally
         {
             if (!isRollBack)
             {
                 isOK = YES;
                 [db commit];
             }
         }
         [db close];
     }];
    
    return isOK;
}

/**
 *  根据套餐id返回该套餐对应的books字符串
 */
- (NSString*)booksidWithID:(NSInteger)ID
{
    __block BOOL isOK = NO;
    __block NSString *booksIDStr = nil;
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBContentListDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         BOOL isRollBack = NO;
         
         @try
         {
             NSString *strSql = [NSString stringWithFormat:@"SELECT * FROM contentList WHERE %@ = ?",@"bookID"];
             NSString *tmpID = [NSString stringWithFormat:@"%ld", ID];
             
             UtilFMResultSet *result = [db executeQuery:strSql,tmpID];
             
             while ([result next])
             {
                 booksIDStr = [result stringForColumn:@"books"];
             }
         }
         @catch (NSException *exception)
         {
             isRollBack = YES;
             [db rollback];
         }
         @finally
         {
             if (!isRollBack)
             {
                 isOK = YES;
                 [db commit];
             }
         }
         [db close];
     }];
    
    return booksIDStr;
}

/**
 *  获取所有套餐
 *
 *  @return 套餐数组
 */
- (NSMutableArray *)getAllContentEntitys
{
    NSMutableArray *contentEntitys = [[NSMutableArray alloc]init];
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBContentListDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         NSString *strSql = @"SELECT * FROM contentList";
         
         UtilFMResultSet *result = [db executeQuery:strSql];
         
         while ([result next])
         {
             HBContentEntity *contentEntity = [[HBContentEntity alloc] init];
             
             contentEntity.bookId = [result intForColumn:@"bookID"];
             contentEntity.total = [result intForColumn:@"total"];
             contentEntity.name = [result stringForColumn:@"name"];
             contentEntity.descriptionStr = [result stringForColumn:@"description"];
             contentEntity.books = [result stringForColumn:@"books"];;
             contentEntity.free_books = [result stringForColumn:@"freeBooks"];
             
             NSString *subscribedStr = [result stringForColumn:@"subscribed"];
             NSString *substatusStr = [result stringForColumn:@"substatus"];
             
             if ([subscribedStr isEqualToString:@"1"]) {
                 contentEntity.subscribed = YES;
             }else{
                 contentEntity.subscribed = NO;
             }
             
             if ([substatusStr isEqualToString:@"1"]) {
                 contentEntity.sub_status = YES;
             }else{
                 contentEntity.sub_status = NO;
             }
             
             [contentEntitys addObject:contentEntity];
         }
         [db close];
     }];
    
    return contentEntitys;
}

- (NSString *)getHBContentListDBPath
{
    NSString *path = [[kFileUtil getAppDataPath] stringByAppendingPathComponent:HBContentList_DB_FILENAME];
    if (![kFileUtil isFileExist:path])
    {
        //如果不存在需要创建数据库,也就是文件拷贝的过程
        [kFileUtil copyFile:[kFileUtil getFilePathWithMainBundle:HBContentList_DB_FILENAME] toPath:path];
    }
    return path;
}

@end
