//
//  DownloadManager.m
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadItem.h"
#import "DownloadConstants.h"

#import "BookEntity.h"
#import "DataEngine.h"

#import "ReadBookDecrypt.h"
#import "LocalSettings.h"

#define kMaxDownloadCount 3

static DownloadManager *_instance;
@interface DownloadManager()
{
}

@property(nonatomic,retain) NSMutableDictionary *pauseQueue;//1、正常暂停 2、下载失败暂停
@property(nonatomic,retain) NSMutableDictionary *waittingQueue;
@property(nonatomic,retain) NSMutableDictionary *downlodingQueue;
@property(nonatomic,retain) NSMutableDictionary *finishedQueue;


-(void)checkDownloadingQueue;
-(void)checkWaiitingQueue;
-(void)checkFinishedQueue;

-(void)startValidItem;

@end



@implementation DownloadManager

+(DownloadManager *)sharedInstance
{
   @synchronized(self)
    {
        if(_instance==nil)
        {
            _instance=[[DownloadManager alloc]init];
            [_instance resetQueuesForLaunch:YES];
        }
    }
    return _instance;
}

- (void)resetQueuesForLaunch:(BOOL)forLaunch
{
    if (self.downlodingQueue != nil) {
        // 全部取消
        [self cancelAllDownloadTask];
    }
    self.downlodingQueue=[NSMutableDictionary new];
    self.waittingQueue=[NSMutableDictionary new];
    self.finishedQueue=[NSMutableDictionary new];
    self.pauseQueue=[NSMutableDictionary new];
    
    NSMutableArray *allTask=[[DownloadStoreManager sharedInstance] getAllStoreDownloadTask];
    if (forLaunch) {
        for(DownloadItem *downItem in allTask)
        {
            [_instance registerDownloadItemCallback:downItem];
            if(downItem.downloadState==DownloadFinished)
            {
                [_instance insertQueue:_instance.finishedQueue checkExistItem:downItem];
            }
            else
            {
                downItem.downloadState=DownloadPaused;
                [_instance insertQueue:_instance.pauseQueue checkExistItem:downItem];
            }
        }
    }
    else {
        for(DownloadItem *downItem in allTask)
        {
            if(downItem.downloadState==DownloadFinished)
            {
                [_instance registerDownloadItemCallback:downItem];
                [_instance insertQueue:_instance.finishedQueue checkExistItem:downItem];
            }
        }
    }
}


-(void)registerDownloadItemCallback:(DownloadItem *)downItem
{
    downItem.DownloadItemStateChangedCallback=^(DownloadItem *callbackItem)
    {
        NSLog(@"DownloadItemStateChangedCallback %d",callbackItem.downloadState);
        switch (callbackItem.downloadState) {
            case DownloadFailed:
            {
                [_instance insertQueue:_instance.pauseQueue checkExistItem:callbackItem];
                [_instance checkPauseQueue];

                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookUrl == %@", callbackItem.originalURL];
                BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
                book.download.status = [NSNumber numberWithInteger:downloadStatusDownloadFailed];
                [CoreDataHelper save];

                NSString* bookName = [NSString stringWithFormat:@"下载《%@》失败", book.bookTitle];
                [LDHudUtil showTextView:bookName inView:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 下载失败
                    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
//                    [info setObject:@(progress) forKey:@"progress"];
                    [info setObject:book.bookUrl forKey:@"url"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress object:book userInfo:info];
                });
            }
                break;
            case DownloadFinished:
            {
                [_instance insertQueue:_instance.finishedQueue checkExistItem:callbackItem];
                [_instance checkFinishedQueue];

                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookUrl == %@", callbackItem.originalURL];
                BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
                book.download.status = @(downloadStatusDownloadSuccess);
                book.download.progress = @(0.98);
                NSString* path = [LocalSettings bookPathForDefaultUser:book.bookTitle];

                // 下载完成，准备解压
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
                [info setObject:@(0.98) forKey:@"progress"];
                [info setObject:book.bookUrl forKey:@"url"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress
                                                                    object:book
                                                                  userInfo:info];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL), ^{
                    // 解压
                    book.download.status = @(downloadStatusUnZipping);
                    NSString* dir = [LocalSettings bookDirectoryForUser:@"0"];

                    BOOL unziped = [DE unZipFile:path toPath:dir];
                    if (unziped) {
                        NSError* error = nil;
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                        
                        BOOL isBookFree = YES;
                        
                        [[ReadBookDecrypt sharedInstance] decryptAllFile:[book.fileId lowercaseString] isBookFree:isBookFree];
                    }
                    else {
                        // 文件解压出错，重下
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[DownloadManager sharedInstance] startDownload:book.bookUrl withLocalPath:path reStartFinished:YES isFree:YES];
                        });
                        return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString* bookName = [NSString stringWithFormat:@"下载《%@》成功", book.bookTitle];
                        [LDHudUtil showTextView:bookName inView:nil];

                        book.hasDown = [NSNumber numberWithBool:YES];
                        book.download.progress = @(1.0f);
                        book.download.status = @(downloadStatusFinished);

                        // 解压完成，可以用了
                        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
                        [info setObject:@(1.0) forKey:@"progress"];
                        [info setObject:book.bookUrl forKey:@"url"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress object:book  userInfo:info];
                        [CoreDataHelper save];
                        // 通知服务端，这本书下载完了
                        [DE requestBookNotify:book success:YES onComplete:nil];
                    });
                });
                
//                [BookOperateUtil bookDidDownload:book.bookId];

            }
                break;
            case DownloadPaused:
            {
                [_instance insertQueue:_instance.pauseQueue checkExistItem:callbackItem];
                [_instance checkPauseQueue];

                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookUrl == %@", callbackItem.originalURL];
                BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
                book.download.status = @(downloadStatusPause);
                [CoreDataHelper save];
            }
                break;
            case DownloadWait:
            {
                
            }
                break;
            default:
                break;
        }
        [_instance startValidItem];
        
    };
    downItem.DownloadItemProgressChangedCallback=^(DownloadItem *callbackItem)
    {
        NSLog(@"---------------download progress:%f", callbackItem.downloadPercent);
        double progress = callbackItem.downloadPercent;
        NSURL *downloadurl = callbackItem.originalURL;
        if (downloadurl == nil)
            downloadurl = callbackItem.url;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookUrl == %@", downloadurl];
        NSLog(@"download progress PRE:%@", predicate);
        BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
        NSLog(@"BOOK:%@", book.bookUrl);
        if (book == nil) {
            NSLog(@"url error:%@", callbackItem.originalURL);
            return;
        }
        book.download.progress = [NSNumber numberWithDouble:progress];
        book.download.status = [NSNumber numberWithInteger:downloadStatusDownloading];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 下载中
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
            [info setObject:@(progress) forKey:@"progress"];
            [info setObject:book.bookUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress
                    object:book
                    userInfo:info];
            });
        //TODO  whether need save to CoreDataHelper
    };

}

-(void)checkPauseQueue
{
    [_pauseQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.originalURL description];

        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }

        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }

        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }
    }];
}

-(void)checkDownloadingQueue
{
    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];

        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }
        
        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
        
        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }
    }];

}

-(void)checkFinishedQueue
{
    [_finishedQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.originalURL description];
        
        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }

        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
        
        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }
    }];
  
}

-(void)checkWaiitingQueue
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];
 
        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }

        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }
        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
    }];
}

-(void)startValidItem
{
//    if([_downlodingQueue count]>=kMaxDownloadCount)
//    {
//        NSLog(@"[_downlodingQueue count]>=kMaxDownloadCount");
//        return;
//    }
    
    DownloadItem *item=  [_waittingQueue.allValues lastObject];
    NSString *url=[item.url description];
    if(item)
    {
        if(![_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue setObject:item forKey:url];
            [item startDownloadTask];
            [self checkDownloadingQueue];
            NSLog(@"checkDownloadingQueue OK");
        }
    }
}

//把等待队列和下载队列中的任务暂停，加入暂停队列
-(void)pauseDownload:(NSString *)resourceUrl
{
    DownloadItem *downItemInWait=[_waittingQueue objectForKey:resourceUrl];
    if(downItemInWait)
    {
        [downItemInWait pauseDownloadTask];
        [_waittingQueue removeObjectForKey:resourceUrl];
        [self insertQueue:_pauseQueue checkExistItem:downItemInWait];
    }
    
    DownloadItem *downItemInDowning=[_downlodingQueue objectForKey:resourceUrl];
    if(downItemInDowning)
    {
        [downItemInDowning pauseDownloadTask];
        [_downlodingQueue removeObjectForKey:resourceUrl];
        [self insertQueue:_pauseQueue checkExistItem:downItemInDowning];
    }
}

-(void)pauseAllDownloadTask
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem pauseDownloadTask];
        [self insertQueue:_pauseQueue checkExistItem:downItem];
    }];
    [_waittingQueue removeAllObjects];
    
    
    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem pauseDownloadTask];
        [self insertQueue:_pauseQueue checkExistItem:downItem];
    }];
    [_downlodingQueue removeAllObjects];
}

-(void)cancelDownload:(NSString *)resourceUrl
{
    DownloadItem *downItem=[_waittingQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_waittingQueue removeObjectForKey:resourceUrl];
    }
    
    downItem=[_downlodingQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_downlodingQueue removeObjectForKey:resourceUrl];
    }

    downItem=[_pauseQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_pauseQueue removeObjectForKey:resourceUrl];
    }

}


-(void)cancelAllDownloadTask
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem cancelDownloadTask];
    }];
    [_waittingQueue removeAllObjects];
    

    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem cancelDownloadTask];
    }];
    [_downlodingQueue removeAllObjects];
    
    
    [_pauseQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        NSLog(@"downItem.downloadDestinationPath=%@,%@",downItem.downloadDestinationPath,downItem.temporaryFileDownloadPath);
        [downItem cancelDownloadTask];
    }];
    [_pauseQueue removeAllObjects];
}

-(void)insertDownloadingQueueItem:(DownloadItem *)downItem
{
    NSString *urlString=[downItem.url description];
    if([_downlodingQueue objectForKey:urlString])
    {
        [_downlodingQueue setObject:downItem forKey:urlString];
    }
}

//向队列queue新增一个下载任务
-(void)insertQueue:(NSMutableDictionary *)queue checkExistItem:(DownloadItem *)downItem
{
    if(queue==nil||downItem==nil||[downItem.url description]==nil)
    {
        return;
    }
    if(![queue objectForKey:[downItem.url description]])
    {
        [queue setObject:downItem forKey:[downItem.url description]];
    }
}

-(BOOL)isExistInDowningQueue:(NSString *)url
{
    return ([_downlodingQueue objectForKey:url])||([_waittingQueue objectForKey:url]);
}

-(BOOL)isExistInFinshQueue:(NSString *)url
{
    if([_finishedQueue objectForKey:url])
    {
        return YES;
    }
    return NO;
}

-(DownloadItem *)getDownloadItemByUrl:(NSString *)url
{
    if([_downlodingQueue objectForKey:url])
    {
        return [_downlodingQueue objectForKey:url];
    }
    else if([_waittingQueue objectForKey:url])
    {
        return [_waittingQueue objectForKey:url];
    }
    else if([_finishedQueue objectForKey:url])
    {
        return [_finishedQueue objectForKey:url];
    }
    else if([_pauseQueue objectForKey:url])
    {
        return [_pauseQueue objectForKey:url];
    }
    return nil;
}

-(BOOL)startDownload:(NSString *)resourceUrl withLocalPath:(NSString *)localPath reStartFinished:(BOOL)restart isFree:(BOOL)isFree
{
    if([self isExistInDowningQueue:resourceUrl])
    {
        return YES;
    }
    
    if(!restart)
    {
       if([self isExistInFinshQueue:resourceUrl])
       {
           return NO;
       }
    }
    
//    resourceUrl=[resourceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //downloadItem 为一个ASIHttpRequest对象，取消后不能重新开始
    DownloadItem *originItem;
    if([_finishedQueue objectForKey:resourceUrl])
    {
        originItem=[_finishedQueue objectForKey:resourceUrl];
    }
    else if([_pauseQueue objectForKey:resourceUrl])
    {
        originItem=[_pauseQueue objectForKey:resourceUrl];
    }
    
    DownloadItem *downItem=[[DownloadItem alloc]initWithURL:[NSURL URLWithString:resourceUrl]];
    downItem.downloadDestinationPath = localPath;
    downItem.temporaryFileDownloadPath = [localPath stringByAppendingString:@".tmp"];
    downItem.receivedLength=originItem.receivedLength;
    downItem.totalLength=originItem.totalLength;
    downItem.downloadPercent=originItem.downloadPercent;
    downItem.isFree = isFree;
//    downItem.retryCount = 3;
    downItem.timeOutSeconds = 30.0f;
    [downItem setAllowResumeForFileDownloads:YES];
    [self registerDownloadItemCallback:downItem];
    
    downItem.downloadState=DownloadWait;
    [self insertQueue:_waittingQueue checkExistItem:downItem];
    [self checkWaiitingQueue];
    [self startValidItem];
    
    return YES;
}


-(BOOL)startDownload:(NSString *)resourceUrl withLocalPath:(NSString *)localPath isFree:(BOOL)isFree
{
    return [self startDownload:resourceUrl withLocalPath:localPath reStartFinished:NO isFree:isFree];
}

-(NSMutableDictionary *)getDownloadingTask
{
    NSMutableDictionary *downingQueue=[NSMutableDictionary new];
    [downingQueue addEntriesFromDictionary:_downlodingQueue];
    
    [downingQueue addEntriesFromDictionary:_waittingQueue];
    
    [downingQueue addEntriesFromDictionary:_pauseQueue];
    return downingQueue;
}

-(NSMutableDictionary *)getFinishedTask
{
    return _finishedQueue;
}
@end
