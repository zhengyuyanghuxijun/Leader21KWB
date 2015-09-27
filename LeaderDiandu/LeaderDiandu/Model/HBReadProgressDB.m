//
//  HBReadProgressDB.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/27.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadProgressDB.h"
#import "UtilFMDatabase.h"
#import "UtilFMDatabaseQueue.h"
#import "FileUtil.h"
#import "HBDataSaveManager.h"

//阅读进度数据库保存路径
#define HBReadProgress_DB_FILENAME  @"hbreadprogress.db"

@implementation HBReadProgressDB

+ (HBReadProgressDB *)sharedInstance {
    
    static HBReadProgressDB *_sharedInstance;
    if(!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[HBReadProgressDB alloc] init];
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
 *  更新阅读进度信息
 *
 *  @param readprogressEntity   阅读进度信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBReadprogress:(HBReadprogressEntity *)readprogressEntity
{
    __block BOOL isOK = NO;
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBReadprogressDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         [db beginTransaction];
         BOOL isRollBack = NO;
         
         @try
         {
             NSString *book_id = readprogressEntity.book_id;
             NSString *progress = readprogressEntity.progress;
             NSString *exam_assigned = [NSString stringWithFormat:@"%d", readprogressEntity.exam_assigned];
             
             BOOL result = [db executeUpdate:@"REPLACE INTO readProgress(book_id, progress, exam_assigned) VALUES(?, ?, ?)",book_id, progress, exam_assigned];
             
             if (result == NO) {
                 //save erro!
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
 *  获取所有阅读进度信息
 *
 *  @return 阅读进度信息字典
 */
- (NSMutableDictionary *)getAllReadprogressDic
{
    NSMutableDictionary *readProgressDic = [[NSMutableDictionary alloc]init];
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBReadprogressDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         NSString *strSql = @"SELECT * FROM readProgress";
         
         UtilFMResultSet *result = [db executeQuery:strSql];
         
         while ([result next])
         {
             HBReadprogressEntity *readprogressEntity = [[HBReadprogressEntity alloc] init];
             
             readprogressEntity.book_id = [result stringForColumn:@"book_id"];
             readprogressEntity.progress = [result stringForColumn:@"progress"];
             
             NSString *exam_assigned = [result stringForColumn:@"exam_assigned"];
             readprogressEntity.exam_assigned = [exam_assigned boolValue];
             
             [readProgressDic setObject:readprogressEntity forKey:readprogressEntity.book_id];
         }
         [db close];
     }];
    
    return readProgressDic;
}

- (NSString *)getHBReadprogressDBPath
{
    NSString *user;
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        user = [dict objectForKey:@"name"];
    }
    
    NSString *path = [[[kFileUtil getAppDataPath] stringByAppendingPathComponent:user]  stringByAppendingPathComponent:HBReadProgress_DB_FILENAME];
    if (![kFileUtil isFileExist:path])
    {
        //如果不存在需要创建数据库,也就是文件拷贝的过程
        [kFileUtil copyFile:[kFileUtil getFilePathWithMainBundle:HBReadProgress_DB_FILENAME] toPath:path];
    }
    return path;
}

@end
