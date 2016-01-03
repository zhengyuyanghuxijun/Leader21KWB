//
//  CoreDataHelper.h
//  Zhucekuaijishi
//
//  Created by libin.tian on 12-8-17.
//
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

/*
 *  保存数据到数据库。
 */
+ (void)save;

/*
 *  保存数据到数据库。
 *  @param  managedObjectContext  根据某个结构的managedObjectContext保存，节省时间。
 */
+ (void)save:(NSManagedObjectContext *)managedObjectContext;

+ (id)createEntity:(NSString*)entity;
+ (id)getOrCreateEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate;

/*
 *  保存数据到数据库。
 *  @param  errorCallback  错误返回码。
 */
+ (void)saveErrorHandler:(void (^)(NSError *))errorCallback;

/*
 *  从数据库里面删除某个表。
 *  @param  entryName  表名。
 */
+ (void)deleteAllWithEntryName:(NSString *)entryName;

/*
 *  从数据库里面删除某个表。
 *  @param  entryName  表名。
 *  @param  predicate  删除条件。
 */
+ (void)deleteAllWithEntryName:(NSString *)entryName
                 withPredicate:(NSPredicate *)predicate;

/*
 *  从数据库里面获取某个表的所有数据。
 *  @param  entryName  表名。
 */
+ (NSArray *)getAllWithEntryName:(NSString *)entryName;

/*
 *  从数据库里面获取某个表的数据。
 *  @param  entryName  表名。
 *  @param  predicate  获取条件。
 */
+ (NSArray *)getAllWithEntryName:(NSString *)entryName
                   withPredicate:(NSPredicate *)predicate;

/*
 *  从数据库里面获取某个表的排序过数据。
 *  @param  entryName  表名。
 *  @param  sortTerm   排序的名称。
 *  @param  ascending  YES从小到大,NO从大到小。
 */
+ (NSArray *)getAllSortedBy:(NSString *)sortTerm
                  ascending:(BOOL)ascending
                  entryName:(NSString *)entryName;

/*
 *  从数据库里面获取某个表的排序过数据。
 *  @param  entryName  表名。
 *  @param  sortTerm   排序的名称。
 *  @param  ascending  从大到小还是从小到大排序。
 *  @param  predicate  获取条件
 */
+ (NSArray *)getAllSortedBy:(NSString *)sortTerm
                  ascending:(BOOL)ascending
                  entryName:(NSString *)entryName
                  predicate:(NSPredicate *)predicate;

/*
 *  从数据库里面获取某个表的数据。
 *  @param  entryName  表名。
 *  @param  sortDescriptors  排序条件。
 */
+ (NSArray *)getAllSortedBy:(NSArray *)sortDescriptors
                  entryName:(NSString *)entryName;

/*
 *  从数据库里面获取某个表的数据。
 *  @param  entryName  表名。
 *  @param  sortDescriptors  排序条件。
 *  @param  predicate  获取条件。
 */
+ (NSArray *)getAllSortedBy:(NSArray *)sortDescriptors
                  entryName:(NSString *)entryName
                  predicate:(NSPredicate *)predicate;


/*
 *  从数据库里面获取某个表的第一条数据。
 *  @param  entryName  表名。
 */
+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName;
+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate;
+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate
                             withSortDescriptors:(NSArray *)sortDescriptors;

/*
 *  从数据库里面获取某个表的最后一条数据。
 *  @param  entryName  表名。
 */
+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName;
+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName
                                  withPredicate:(NSPredicate *)predicate;
+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName
                                  withPredicate:(NSPredicate *)predicate
                            withSortDescriptors:(NSArray *)sortDescriptors;

/*
 *  从数据库里面获取某个表的数据条数。
 *  @param  entryName  表名。
 */
+ (NSUInteger)getCountByEntryName:(NSString *)entryName;
+ (NSUInteger)getCountByEntryName:(NSString *)entryName
                    withPredicate:(NSPredicate *)predicate;

+ (NSArray *)sortArray:(NSArray *)dataArray
              withKey:(NSString *)key
            ascending:(BOOL)ascending;


@end
