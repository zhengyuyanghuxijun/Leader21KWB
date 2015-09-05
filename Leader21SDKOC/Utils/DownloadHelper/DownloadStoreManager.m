//
//  DownloadStoreManager.m
//  DownloadDemo
//
//  Created by Peter Yuen on 7/1/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "DownloadStoreManager.h"

#import "DownloadConstants.h"
#import "BookEntity.h"
#import "DataEngine.h"

static DownloadStoreManager *_instance;

@interface DownloadStoreManager ()

@end


@implementation DownloadStoreManager

+(DownloadItem *)transferToItem:(DownloadEntity *)entity
{
    DownloadItem *item=[[DownloadItem alloc]init];
    if (entity.downloadUrl != nil) {
        item.url = [NSURL URLWithString:entity.downloadUrl];
    }
    item.temporaryFileDownloadPath=entity.temporaryFileDownloadPath;
    item.downloadDestinationPath=entity.downloadDestinationPath;
    item.totalLength=[entity.totalSize doubleValue];
    item.receivedLength=[entity.currentSize doubleValue];
    item.downloadState=[entity.status intValue];
    item.downloadPercent=[entity.status doubleValue];
    item.isFree = [entity.isFree boolValue];
    return item;
}

+(void)transfer:(DownloadItem *)item toEntity:(DownloadEntity *)entity;
{
    if([item.url description])
    {
        entity.downloadUrl=[item.url description];
    }
    entity.downloadDestinationPath=item.downloadDestinationPath;
    entity.temporaryFileDownloadPath=item.temporaryFileDownloadPath;
    entity.status=[NSNumber numberWithInt:item.downloadState];
    entity.totalSize=[NSNumber numberWithDouble:item.totalLength];
    entity.currentSize=[NSNumber numberWithDouble:item.receivedLength];
    entity.progress=[NSNumber numberWithDouble:item.downloadPercent];
    entity.isFree = @(item.isFree);
}

+(DownloadStoreManager *)sharedInstance
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance=[[DownloadStoreManager alloc]init];
        });
    }
    return _instance;
}

-(BOOL)isExistDownloadTask:(NSString *)url
{
    if([self queryEntityByUrl:url])
    {
        return YES;
    }
    return NO;
}

-(DownloadEntity *)queryEntityByUrl:(NSString *)url
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND downloadUrl == %@", @(0), url];
    DownloadEntity* e = (DownloadEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"DownloadEntity" withPredicate:predicate];
    return e;
}

-(NSMutableArray *)getAllStoreDownloadTask
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userId == %@", @(0)];
    NSArray* retlist = [CoreDataHelper getAllWithEntryName:@"DownloadEntity" withPredicate:predicate];
    
    NSMutableArray *itemlist=[NSMutableArray new];
    for(DownloadEntity *entity in retlist)
    {
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"bookUrl == %@", entity.downloadUrl];
        BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:pre];
        entity.book = book;
        [itemlist addObject:[DownloadStoreManager transferToItem:entity]];
    }
    return itemlist;
}

-(void)insertDownloadTask:(DownloadItem *)item
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if(![self isExistDownloadTask:[item.url description]])
    {
        DownloadEntity* entity = (DownloadEntity*)[CoreDataHelper createEntity:@"DownloadEntity"];
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"bookUrl == %@", item.url];
        BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:pre];
        
        [DownloadStoreManager transfer:item toEntity:entity];

        entity.book = book;
        entity.progress = @(0.005);
        entity.status = [NSNumber numberWithInteger:downloadStatusDownloading];
        entity.isFree = @(0);
        entity.userId = @(0);

        [CoreDataHelper save];
        
        // 开始下载
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
        [info setObject:@(0.005) forKey:@"progress"];
        [info setObject:book.bookUrl forKey:@"url"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress
                                                            object:book
                                                          userInfo:info];

    }
    });
}

-(void)deleteDownloadTask:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
    DownloadEntity *entity=[self queryEntityByUrl:url];
    if(entity) {
        NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
        [managedObjectContext deleteObject:entity];
        [CoreDataHelper save];
    }
    });
}

-(void)updateDownloadTask:(DownloadItem *)item
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DownloadEntity *entity=[self queryEntityByUrl:[item.url description]];
        if(entity)
        {
            [DownloadStoreManager transfer:item toEntity:entity];
            [CoreDataHelper save];
        }
    });
}
@end
