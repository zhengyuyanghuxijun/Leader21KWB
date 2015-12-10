//
//  Leader21SDKOC.m
//  Leader21SDKOC
//
//  Created by leader on 15/7/1.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#import "Leader21SDKOC.h"
#import "LocalSettings.h"
#import "DownloadManager.h"
#import "ReadBookViewController.h"
#import "DownloadEntity.h"
#import "ReadBookDecrypt.h"
//#import "BookEntity+NSDictionary.h"

@interface Leader21SDKOC()

@property (nonatomic, strong) NSString *hostUrl;
@property (nonatomic, strong) NSString *mAppId;

@end

@implementation Leader21SDKOC

+ (Leader21SDKOC *)sharedInstance {
    static Leader21SDKOC * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Leader21SDKOC alloc] init];
    });
    
    return _sharedInstance;
}

- (void)setServerUrl:(NSString *)serverUrl
{
    self.hostUrl = serverUrl;
    [DataEngine sharedInstance].serverUrl = serverUrl;
}

- (void)setAppKey:(NSString *)appKey
{
    self.mAppId = appKey;
    DE.mAppId = appKey;
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataEngine sharedInstance] managedObjectContext];
    [self setManagedObjectContext:managedObjectContext];
}

- (NSString *)appKey
{
    return self.mAppId;
}

-(void)requestBookInfo:(NSString *)bookIds onComplete:(ResponseBookListBlock)block
{
    [DE requestBookInfo:bookIds onComplete:block];
}

- (void)startDownloadBookByDict:(NSDictionary *)dict
{
    BookEntity *entity = [BookEntity itemWithDictionary:dict];
    [self startDownloadBook:entity];
}

- (void)startDownloadBook:(BookEntity *)book
{
    if (book == nil){
        NSLog(@" book is null ");
        return;
    }
    //TODO generate download url "?book_id=%s&file_id=%s&app_key=%s"
    NSString* bookUrl = [NSString stringWithFormat:
                         @"%@%@?book_id=%@&file_id=%@&app_key=%@",
                         _hostUrl,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];

    NSLog(@"book download url %@",bookUrl);
    NSString* path = [LocalSettings bookPathForDefaultUser:book.bookTitle];
    NSLog(@"book download path %@",path);
    book.bookUrl = bookUrl;
    BOOL start = [[DownloadManager sharedInstance] startDownload:bookUrl withLocalPath:path isFree:YES];
    if (!start) {
        NSLog(@"Download need restart");
        start = [[DownloadManager sharedInstance] startDownload:book.bookUrl withLocalPath:path reStartFinished:YES isFree:YES];
    }

    NSLog(@"download book start?  %@", start?@"YES":@"NO");
    [CoreDataHelper save];
}

- (void)pauseDownload:(BookEntity *)book
{
    if (book) {
        NSString *bookUrl = book.bookUrl;
        if (bookUrl == nil) {
            bookUrl = [NSString stringWithFormat:@"%@%@?book_id=%@&file_id=%@&app_key=%@", _hostUrl,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];
        }
        [[DownloadManager sharedInstance] pauseDownload:bookUrl];
        book.download.status = @(downloadStatusPause);
        [CoreDataHelper save];
        // 暂停
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
        [info setObject:@(-1.0) forKey:@"progress"];
        [info setObject:book.bookUrl forKey:@"url"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress object:book userInfo:info];
    }
}

- (void)pauseAllDownloadTask
{
    [[DownloadManager sharedInstance] pauseAllDownloadTask];
}

- (void)cancelDownload:(BookEntity *)book
{
    if (book) {
        NSString *bookUrl = book.bookUrl;
        if (bookUrl == nil) {
            bookUrl = [NSString stringWithFormat:@"%@%@?book_id=%@&file_id=%@&app_key=%@", _hostUrl,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];
        }
        [[DownloadManager sharedInstance] cancelDownload:bookUrl];
        book.download.status = @(downloadStatusNone);
        [CoreDataHelper save];
        // 取消下载
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
        [info setObject:@(-1.0) forKey:@"progress"];
        [info setObject:book.bookUrl forKey:@"url"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress object:book userInfo:info];
    }
}

- (BOOL)isBookDownloaded:(BookEntity *)book
{
    BOOL isdownloaded = [LocalSettings findBookLoginOrNot:book.fileId];
    
    NSLog(@"isBookDownloaded  bookid = %@ isdownloaded = %@",book.fileId,isdownloaded?@"YES":@"NO");
    return isdownloaded;
}

- (BOOL)isBookDownloading:(BookEntity *)book
{
    NSString* bookUrl = [NSString stringWithFormat:
                         @"%@%@?book_id=%@&file_id=%@&app_key=%@",
                         _hostUrl,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];
    
//    NSLog(@"book download url %@",bookUrl);
    
    BOOL isdownload = [[DownloadManager sharedInstance] isExistInDowningQueue:bookUrl];
    
    NSLog(@"isBookDownloading  result %@", isdownload?@"YES":@"NO");
    return isdownload;
}

- (void)readBook:(BookEntity *)book useNavigation:(UINavigationController *)navigationController
{
    NSString* folder = [LocalSettings bookPathForDefaultUser:[book.fileId lowercaseString]];
    ReadBookViewController* vc = [[ReadBookViewController alloc] init];
    vc.folderName = folder;
    vc.navBarTitle = book.bookTitle;
    vc.bookID = book.bookId.longLongValue;
    [navigationController pushViewController:vc animated:YES];
}

- (DownloadEntity *)getCoreDataDownload:(NSString *)url
{
    DownloadEntity* download = nil;
    if (url) {
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"downloadUrl == %@", url];
        download = (DownloadEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"DownloadEntity" withPredicate:pre];
    }
    return download;
}

- (NSMutableArray *)getLocalBooks
{
    NSMutableArray* bookArray = [NSMutableArray arrayWithCapacity:64];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* path0 = [LocalSettings bookDirectoryForUser:@"0"];
    NSDirectoryEnumerator* direnum = [fm enumeratorAtPath:path0];
    NSString* fileName = @"";
    while ((fileName = [direnum nextObject]) != nil) {
        NSLog(@"---------------FILEID:%@", fileName);
        NSString* pathFull = [NSString stringWithFormat:@"%@/%@", path0, fileName];
        BOOL flag;
        [fm fileExistsAtPath:pathFull isDirectory:&flag];
        if(flag) {
            [direnum skipDescendants];
        }
        NSDirectoryEnumerator* subEnum = [fm enumeratorAtPath:pathFull];
        if (subEnum.nextObject != nil) {
            // 找书
            NSString* fileId = [fileName uppercaseString];
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"fileId == %@", fileId];
            BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
            [bookArray addObject:book];
            
            NSInteger integerTmp = [CoreDataHelper getCountByEntryName:@"BookEntity"];
        }
    }
    return bookArray;
}

- (BOOL)deleteLocalBooks:(NSMutableArray *)books
{
    for (BookEntity* item in books) {
        // 删除
        NSString* fileId = [item.fileId lowercaseString];
        NSString* path1 = [LocalSettings bookPathForDefaultUser:fileId];
        NSError* error = nil;
        NSLog(@"delete book %@",path1);
        if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
            [[NSFileManager defaultManager] removeItemAtPath:path1 error:&error];
        }
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"fileId == %@", fileId];
        BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
        
        book.download.status = @(downloadStatusNone);
        book.download.progress = @(0.0);
        
        book.bookUrl = nil;
        book.download = nil;
        book.hasDown = nil;
        
//        book.hasDown = [NSNumber numberWithBool:NO];
//        book.download.progress = @(0.0f);
//        book.download.status = @(downloadStatusNone);

        [CoreDataHelper save];
    }
    return YES;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)moContext
{
    [CoreDataEngine sharedInstance].managedObjectContext = moContext;
}

- (BOOL)bookPressed:(BookEntity*)book useNavigation:(UINavigationController *)navigation
{
    // 如果正在下载中，不做任何处理
    if (book.download != nil) {
        if([[DownloadManager sharedInstance] isExistInDowningQueue:book.bookUrl])
        {
            [[DownloadManager sharedInstance] pauseDownload:book.bookUrl];
            book.download.status = @(downloadStatusPause);
            [CoreDataHelper save];
            
            // 暂停
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:2];
            [info setObject:@(-1.0) forKey:@"progress"];
            [info setObject:book.bookUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_bookDownloadProgress object:book userInfo:info];
            
            return YES;
        }
    }
    
    return [self bookPressedCheckDownload:book useNavigation:navigation];
}

- (BOOL)bookPressedCheckDownload:(BookEntity*)book useNavigation:(UINavigationController *)navigation
{
    BOOL findBook = [LocalSettings findBookLoginOrNot:book.fileId];
    if (findBook) {
        BOOL canOpen = YES;
        if (book.download != nil) {
            if (book.download.status.integerValue == downloadStatusUnZipping) {
                canOpen = NO;
            }
            else if (book.download.status.integerValue == downloadStatusDownloadSuccess) {
                canOpen = NO;
                NSString* path = [LocalSettings bookPathForDefaultUser:book.fileId];
                
                // 解压
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
                    });
                });
            }
        }
        if (!canOpen) {
            return YES;
        }
        book.download.status = @(downloadStatusFinished);
        // 进入书阅读页面
        NSString* folder = [LocalSettings bookPathForDefaultUser:[book.fileId lowercaseString]];
        if (folder.length > 0) {
            ReadBookViewController* vc = [[ReadBookViewController alloc] init];
            vc.folderName = folder;
            vc.navBarTitle = book.bookTitle;
            vc.bookID = book.bookId.longLongValue;
            [navigation pushViewController:vc animated:YES];
            
            //            if (!book.hasDown.boolValue) {
            //                book.hasDown = [NSNumber numberWithBool:YES];
            //                [CoreDataHelper save];
            //                [self bookDidDownload:book.fileId];
            //            }
            
            //            if (!book.hasBook.boolValue) {
            //                // 告诉服务端，这本书算下载过了
            //                [self bookDidDownload:book.fileId];
            //            }
        }
        return YES;
    }
//    else {
//        // 下载
//        [self startDownloadBook:book];
//    }
    return NO;
}

@end
