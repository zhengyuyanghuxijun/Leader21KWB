//
//  HBMsgEntityDB.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/14.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMsgEntityDB.h"
#import "UtilFMDatabase.h"
#import "UtilFMDatabaseQueue.h"
#import "FileUtil.h"
#import "TimeIntervalUtils.h"
#import "HBSystemMsgEntity.h"

//课本信息数据库保存路径
#define HBMsgEntity_DB_FILENAME  @"msgentity.db"

@implementation HBMsgEntityDB

+ (HBMsgEntityDB *)sharedInstance {
    
    static HBMsgEntityDB *_sharedInstance;
    if(!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[HBMsgEntityDB alloc] init];
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
 *  更新消息
 *
 *  @param msgEntityArr  消息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBMsgEntity:(NSArray *)msgEntityArr
{
    __block BOOL isOK = NO;
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBMsgEntityDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         [db beginTransaction];
         BOOL isRollBack = NO;
         
         @try
         {
             for (HBSystemMsgEntity *msgEntity in msgEntityArr) {
                 BOOL result = [db executeUpdate:@"REPLACE INTO msgEntity(msgID, body, userId, createdTime) VALUES(?, ?, ?, ?)",msgEntity.systemMsgId, msgEntity.body, msgEntity.user_id, msgEntity.created_time];
                 
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
 *  获取所有消息
 *
 *  @return 消息数组
 */
- (NSMutableArray *)getAllMsgEntity
{
    NSMutableArray *msgEntityArr = [[NSMutableArray alloc]init];
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBMsgEntityDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         NSString *strSql = @"SELECT * FROM msgEntity";
         
         UtilFMResultSet *result = [db executeQuery:strSql];
         
         while ([result next])
         {
             HBSystemMsgEntity *msgEntity = [[HBSystemMsgEntity alloc] init];
             msgEntity.systemMsgId = [result stringForColumn:@"msgID"];
             msgEntity.body = [result stringForColumn:@"body"];
             msgEntity.user_id = [result stringForColumn:@"userId"];
             msgEntity.created_time = [result stringForColumn:@"createdTime"];
             
             [msgEntityArr addObject:msgEntity];
         }
         [db close];
     }];
    
    return msgEntityArr;
}

- (NSString *)getHBMsgEntityDBPath
{
    NSString *path = [[kFileUtil getAppDataPath] stringByAppendingPathComponent:HBMsgEntity_DB_FILENAME];
    if (![kFileUtil isFileExist:path])
    {
        //如果不存在需要创建数据库,也就是文件拷贝的过程
        [kFileUtil copyFile:[kFileUtil getFilePathWithMainBundle:HBMsgEntity_DB_FILENAME] toPath:path];
    }
    return path;
}

@end
