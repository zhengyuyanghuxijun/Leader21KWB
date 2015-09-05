//
//  CoreDataHelper.m
//  Zhucekuaijishi
//
//  Created by libin.tian on 12-8-17.
//
//

#import "CoreDataHelper.h"
#import "CoreDataEngine.h"

@implementation CoreDataHelper

+ (void)save {
    [[CoreDataEngine sharedInstance] saveContext];
}

+ (void)save:(NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
}


+ (id)createEntity:(NSString*)entity
{
    return [NSEntityDescription insertNewObjectForEntityForName:entity
                                         inManagedObjectContext:[[CoreDataEngine sharedInstance] managedObjectContext]];
}

+ (id)getOrCreateEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate
{
    id obj = [CoreDataHelper getFirstObjectWithEntryName:entity withPredicate:predicate];
    if (obj == nil) {
        obj = [CoreDataHelper createEntity:entity];
    }
    
    return obj;
}


+ (void)saveErrorHandler:(void (^)(NSError *))errorCallback {
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    if (managedObjectContext) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Handle the error.
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }
}

+ (void)deleteAllWithEntryName:(NSString *)entryName {
    [self deleteAllWithEntryName:entryName withPredicate:nil];
}

+ (void)deleteAllWithEntryName:(NSString *)entryName
                  withPredicate:(NSPredicate *)predicate {
    if (!entryName || [entryName length] == 0) return;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    [request setIncludesPropertyValues:NO];
    
    if (predicate) [request setPredicate:predicate];
    
    NSError *error = nil;
	NSArray *objectResults = [managedObjectContext
                              executeFetchRequest:request
                              error:&error];
    
    if (objectResults && objectResults.count > 0 ) {
        for (NSManagedObject *object in objectResults) {
            [managedObjectContext deleteObject:object];
        }
//        [self save]; // 由外部调用save方法
    }
}

+ (NSArray *)getAllWithEntryName:(NSString *)entryName {
    return  [self getAllWithEntryName:entryName withPredicate:nil];
}

+ (NSArray *)getAllWithEntryName:(NSString *)entryName
                    withPredicate:(NSPredicate *)predicate {
    if (!entryName || [entryName length] == 0) return nil;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (predicate) [request setPredicate:predicate];
    
    NSError *error = nil;
	NSArray *objectResults = [managedObjectContext
                              executeFetchRequest:request
                              error:&error];
    return objectResults;
}

+ (NSArray *)getAllSortedBy:(NSString *)sortTerm
                   ascending:(BOOL)ascending
                   entryName:(NSString *)entryName {
    if ((!entryName || [entryName length] == 0) || (!sortTerm || [sortTerm length] == 0)) return nil;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    return  [self getAllSortedBy:sortDescriptors entryName:entryName];
}

+ (NSArray *)getAllSortedBy:(NSString *)sortTerm
                   ascending:(BOOL)ascending
                   entryName:(NSString *)entryName
                   predicate:(NSPredicate *)predicate {
    if ((!entryName || [entryName length] == 0) || (!sortTerm || [sortTerm length] == 0)) return nil;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    return [self getAllSortedBy:sortDescriptors
                      entryName:entryName
                      predicate:predicate];
}

+ (NSArray *)getAllSortedBy:(NSArray *)sortDescriptors
                   entryName:(NSString *)entryName {
    return [self getAllSortedBy:sortDescriptors
                      entryName:entryName
                      predicate:nil];
}

+ (NSArray *)getAllSortedBy:(NSArray *)sortDescriptors
                   entryName:(NSString *)entryName
                   predicate:(NSPredicate *)predicate {
    if (!entryName || [entryName length] == 0) return nil;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    if (sortDescriptors && [sortDescriptors count] > 0) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error = nil;
	NSArray *objectResults = [managedObjectContext
                              executeFetchRequest:request
                              error:&error];
    return objectResults;
}

+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName {
    return [self getFirstObjectWithEntryName:entryName withPredicate:nil];
}

+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate {
    return  [self getFirstObjectWithEntryName:entryName
                                withPredicate:predicate
                          withSortDescriptors:nil];
}

+ (NSManagedObject *)getFirstObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate
                             withSortDescriptors:(NSArray *)sortDescriptors {
    if (!entryName || [entryName length] == 0) return nil;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    if (sortDescriptors && [sortDescriptors count] > 0) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error = nil;
	NSArray *objectResults = [managedObjectContext
                              executeFetchRequest:request
                              error:&error];
    if (!objectResults || [objectResults count] == 0) {
        return nil;
    }
    return [objectResults objectAtIndex:0];
}

+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName {
    return [self getLastObjectWithEntryName:entryName withPredicate:nil];
}

+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate {
    return [self getLastObjectWithEntryName:entryName
                              withPredicate:predicate
                        withSortDescriptors:nil];
}

+ (NSManagedObject *)getLastObjectWithEntryName:(NSString *)entryName
                                   withPredicate:(NSPredicate *)predicate
                             withSortDescriptors:(NSArray *)sortDescriptors {
    if (!entryName || [entryName length] == 0)  return nil;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    if (sortDescriptors && [sortDescriptors count] > 0) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error = nil;
	NSArray *objectResults = [managedObjectContext
                              executeFetchRequest:request
                              error:&error];
    if (!objectResults || [objectResults count] == 0) {
        return nil;
    }
    return [objectResults lastObject];
}

+ (NSUInteger )getCountByEntryName:(NSString *)entryName {
    return [self getCountByEntryName:entryName withPredicate:nil];
}

+ (NSUInteger )getCountByEntryName:(NSString *)entryName
                     withPredicate:(NSPredicate *)predicate {
    if (!entryName || [entryName length] == 0) return 0;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entryName
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
	NSUInteger count = [managedObjectContext
                        countForFetchRequest:request
                        error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    return count;
}

+ (NSArray *)sortArray:(NSArray *)dataArray
              withKey:(NSString *)key
            ascending:(BOOL)ascending {
    if (!dataArray || !key) return nil;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
