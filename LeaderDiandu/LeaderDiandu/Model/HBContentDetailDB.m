//
//  HBContentDetailDB.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/11.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentDetailDB.h"
#import "UtilFMDatabase.h"
#import "UtilFMDatabaseQueue.h"
#import "FileUtil.h"
#import "HBDataSaveManager.h"
#import "HBContentDetailEntity.h"

//课本信息数据库保存路径
#define HBContentDetail_DB_FILENAME  @"hbcontentdetail.db"

@implementation HBContentDetailDB

+ (HBContentDetailDB *)sharedInstance {
    
    static HBContentDetailDB *_sharedInstance;
    if(!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[HBContentDetailDB alloc] init];
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
 *  更新课本信息
 *
 *  @param contentDetailArr   课本信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBContentDetail:(NSArray *)contentDetailArr
{
    __block BOOL isOK = NO;
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBContentDetailDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         [db beginTransaction];
         BOOL isRollBack = NO;
         
         @try
         {
             for (NSDictionary *dic in contentDetailArr) {
                 
                 NSNumber *bookIdNum = [NSNumber numberWithInteger:[[dic objectForKey:@"ID"] integerValue]];
                 NSNumber *unitNum = [NSNumber numberWithInteger:[[dic objectForKey:@"UNIT"] integerValue]];
                 
                 BOOL result = [db executeUpdate:@"REPLACE INTO contentDetail(bookID, unit, bookLevel, bookSrno, bookTitle, bookTitleCN, bookType, fileID, grade) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",bookIdNum, unitNum, [dic objectForKey:@"BOOK_LEVEL"], [dic objectForKey:@"BOOK_SRNO"], [dic objectForKey:@"BOOK_TITLE"], [dic objectForKey:@"BOOK_TITLE_CN"], [dic objectForKey:@"BOOK_TYPE"], [dic objectForKey:@"FILE_ID"], [dic objectForKey:@"GRADE"]];
                 
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
 *  读取课本信息
 *
 *  @param booksIDArr 课本ID号数组
 *
 *  @return 课本数组
 */
- (NSMutableArray*)booksWithBooksIDArr:(NSArray*)booksIDArr
{
    __block BOOL isOK = NO;
    NSMutableArray *booksArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    UtilFMDatabaseQueue * queue = [UtilFMDatabaseQueue databaseQueueWithPath:[self getHBContentDetailDBPath]];
    [queue inDatabase:^(UtilFMDatabase *db)
     {
         BOOL isRollBack = NO;
         for (NSString *bookIDStr in booksIDArr) {
             @try
             {
                 NSString *strSql = [NSString stringWithFormat:@"SELECT * FROM contentDetail WHERE %@ = ?", @"bookID"];
                 
                 UtilFMResultSet *result = [db executeQuery:strSql,bookIDStr];
                 
                 while ([result next])
                 {
                     HBContentDetailEntity *contentDetailEntity = [[HBContentDetailEntity alloc] init];
                     
                     contentDetailEntity.ID = [result intForColumn:@"bookID"];
                     contentDetailEntity.UNIT = [result intForColumn:@"unit"];
                     
                     contentDetailEntity.BOOK_LEVEL = [result stringForColumn:@"bookLevel"];
                     contentDetailEntity.BOOK_SRNO = [result stringForColumn:@"bookSrno"];
                     contentDetailEntity.BOOK_TITLE = [result stringForColumn:@"bookTitle"];
                     contentDetailEntity.BOOK_TITLE_CN = [result stringForColumn:@"bookTitleCN"];
                     contentDetailEntity.BOOK_TYPE = [result stringForColumn:@"bookType"];
                     contentDetailEntity.FILE_ID = [result stringForColumn:@"fileID"];
                     contentDetailEntity.GRADE = [result stringForColumn:@"grade"];
                     
                     [booksArr addObject:contentDetailEntity];
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
         }
         
         [db close];
     }];
    
    return booksArr;
}

- (NSString *)getHBContentDetailDBPath
{
    NSString *user;
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        user = [dict objectForKey:@"name"];
    }
    
    NSString *path = [[[kFileUtil getAppDataPath] stringByAppendingPathComponent:user]  stringByAppendingPathComponent:HBContentDetail_DB_FILENAME];
    if (![kFileUtil isFileExist:path])
    {
        //如果不存在需要创建数据库,也就是文件拷贝的过程
        [kFileUtil copyFile:[kFileUtil getFilePathWithMainBundle:HBContentDetail_DB_FILENAME] toPath:path];
    }
    return path;
}

@end
