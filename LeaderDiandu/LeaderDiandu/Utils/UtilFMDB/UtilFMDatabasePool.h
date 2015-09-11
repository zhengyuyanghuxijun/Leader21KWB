//
//  UtilFMDatabasePool.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class UtilFMDatabase;

/** Pool of `<UtilFMDatabase>` objects.

 ### See also
 
 - `<UtilFMDatabaseQueue>`
 - `<UtilFMDatabase>`

 @warning Before using `UtilFMDatabasePool`, please consider using `<UtilFMDatabaseQueue>` instead.

 If you really really really know what you're doing and `UtilFMDatabasePool` is what
 you really really need (ie, you're using a read only database), OK you can use
 it.  But just be careful not to deadlock!

 For an example on deadlocking, search for:
 `ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_UtilFMDatabaseQUEUE_INSTEAD`
 in the main.m file.
 */

@interface UtilFMDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
}

@property (atomic, retain) NSString *path;
@property (atomic, assign) id delegate;
@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;
@property (atomic, readonly) int openFlags;

///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `UtilFMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath;

/** Create pool using path and specified flags

  @param aPath The file path of the database.
  @param openFlags Flags passed to the openWithFlags method of the database

 @return The `UtilFMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `UtilFMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath;

/** Create pool using path and specified flags.

 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database

 @return The `UtilFMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfCheckedInDatabases;

/** Number of checked-out databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfCheckedOutDatabases;

/** Total number of databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.

 @param block The code to be run on the `UtilFMDatabasePool` pool.
 */

- (void)inDatabase:(void (^)(UtilFMDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.

 @param block The code to be run on the `UtilFMDatabasePool` pool.
 */

- (void)inTransaction:(void (^)(UtilFMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the `UtilFMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(void (^)(UtilFMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the `UtilFMDatabasePool` pool.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[UtilFMDatabase startSavePointWithName:error:]>` instead.
*/

- (NSError*)inSavePoint:(void (^)(UtilFMDatabase *db, BOOL *rollback))block;
#endif

@end


@interface NSObject (UtilFMDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool. */

- (BOOL)databasePool:(UtilFMDatabasePool*)pool shouldAddDatabaseToPool:(UtilFMDatabase*)database;

/** Tells the delegate that database was added to the pool. */

- (void)databasePool:(UtilFMDatabasePool*)pool didAddDatabase:(UtilFMDatabase*)database;

@end

