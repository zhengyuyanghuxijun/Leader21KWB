//
//  CoreDataEngine.h
//  ContinueEduIPhone
//
//  Created by liang wang on 12-5-4.
//  Copyright (c) 2012年 cdel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataEngine : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataEngine *)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
