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
//#import "BookEntity+NSDictionary.h"

@interface Leader21SDKOC()
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

- (void)setAppKey:(NSString *)appKey
{
    self.mAppId = appKey;
    DE.mAppId = appKey;
}

- (NSString *)appKey
{
    return self.mAppId;
}

-(void)requestBookInfo:(NSArray *)bookIds onComplete:(ResponseBookListBlock)block
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
                         HOST,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];

    NSLog(@"book download url %@",bookUrl);
    NSString* path = [LocalSettings bookPathForDefaultUser:book.bookTitle];
    NSLog(@"book download path %@",path);
    book.bookUrl = bookUrl;
    BOOL start = [[DownloadManager sharedInstance] startDownload:bookUrl withLocalPath:path isFree:YES];

    NSLog(@"download book start?  %@", start?@"YES":@"NO");
    [CoreDataHelper save];
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
                         HOST,API_DOWNLOAD_BOOK,book.bookId,book.fileId,_mAppId];
    
    NSLog(@"book download url %@",bookUrl);
    
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
    }
    return YES;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)moContext
{
    [CoreDataEngine sharedInstance].managedObjectContext = moContext;
}
@end
