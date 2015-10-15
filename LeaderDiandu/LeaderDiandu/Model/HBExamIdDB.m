//
//  HBExamIdDB.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/15.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBExamIdDB.h"
#import "UtilFMDatabase.h"
#import "UtilFMDatabaseQueue.h"
#import "FileUtil.h"

//作业ID数据库保存路径
#define HBExamId_DB_FILENAME  @"examid.db"

@implementation HBExamIdDB

+ (HBExamIdDB *)sharedInstance {
    
    static HBExamIdDB *_sharedInstance;
    if(!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[HBExamIdDB alloc] init];
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
 *  更新作业ID
 *
 *  @param ExamIdArr 作业ID数组
 *
 *  @return 操作结果
 */
- (BOOL)updateHBExamId:(NSArray *)ExamIdArr
{
    [self deleteAllExamId];
    
    __block BOOL isOK = NO;
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBExamIdDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         [db beginTransaction];
         BOOL isRollBack = NO;
         
         @try
         {
             for (NSString *examIdStr in ExamIdArr) {
                 BOOL result = [db executeUpdate:@"REPLACE INTO examId(exam_id) VALUES(?)", examIdStr];
                 
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
 *  获取所有作业ID
 *
 *  @return 作业ID数组
 */
- (NSMutableArray *)getAllExamId
{
    NSMutableArray *examIdArr = [[NSMutableArray alloc] init];
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBExamIdDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         NSString *strSql = @"SELECT * FROM examId";
         
         UtilFMResultSet *result = [db executeQuery:strSql];
         
         while ([result next])
         {
             NSString *examIdStr = [result stringForColumn:@"exam_id"];
             [examIdArr addObject:examIdStr];
         }
         
         [db close];
     }];
    
    return examIdArr;
}

/**
 *  删除所有作业ID
 *
 *  @return 操作结果
 */
- (BOOL)deleteAllExamId
{
    __block BOOL isOK = NO;
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBExamIdDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
    {
        [db beginTransaction];
        NSString *str = [NSString stringWithFormat:@"delete from exam_id"];
        isOK = [db executeUpdate:str];
        [db commit];
        [db close];
    }];
    
    return isOK;
}

- (NSString *)getHBExamIdDBPath
{
    NSString *path = [[kFileUtil getAppDataPath] stringByAppendingPathComponent:HBExamId_DB_FILENAME];
    if (![kFileUtil isFileExist:path])
    {
        //如果不存在需要创建数据库,也就是文件拷贝的过程
        [kFileUtil copyFile:[kFileUtil getFilePathWithMainBundle:HBExamId_DB_FILENAME] toPath:path];
    }
    return path;
}

@end
