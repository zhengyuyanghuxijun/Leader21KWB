//
//  Leader21SDKOC.h
//  Leader21SDKOC
//
//  Created by leader on 15/7/1.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookEntity.h"
#import "DownloadEntity.h"

typedef enum  {
    DownloadNotStart=0,
    DownloadWait=1,
    Downloading,
    DownloadPaused,
    DownloadFailed,
    DownloadFinished,
}DownloadItemState;

typedef enum {
    downloadStatusNone = 0,
    downloadStatusDownloading = Downloading,
    downloadStatusDownloadFailed = DownloadFailed,
    downloadStatusDownloadSuccess = DownloadFinished,
    downloadStatusPause = DownloadPaused,
    downloadStatusUnZipping = 8,
    downloadStatusFinished = 10,
}downloadStatus;

typedef void (^ResponseBookListBlock)(NSArray *booklist, NSInteger errorCode, NSString* errorMsg);

@interface Leader21SDKOC : NSObject

+ (Leader21SDKOC *)sharedInstance;

/**设置服务器地址
 @param hostUrl 服务器地址
 */
- (void)setLeaderHost:(NSString *)hostUrl;

/**设置app的appKey，此appKey从leader21网站获取
 @param appKey leader21 appKey
 */
- (void)setAppKey:(NSString *)appKey;

/**获取设置的leader21 appKey
 */
- (NSString *)appKey;

/**根据bookId获取book的详细信息
 @param bookIds bookId列表
        block： 回调，返回书本详细信息
 */
- (void) requestBookInfo:(NSString *)bookIds
              onComplete:(ResponseBookListBlock)block;

/**根据bookId下载一本book
 @param bookId bookId
 监听下载信息，注册
 [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateProgress:)
            name:kNotification_bookDownloadProgress
            object:nil];
 */
- (void) startDownloadBook:(BookEntity *)book;
- (void) startDownloadBookByDict:(NSDictionary *)dict;
/**
 * 书籍是否正在下载
 * @param book
 * @return 如正在下载，返回true，否则返回false
 */
- (BOOL) isBookDownloading:(BookEntity *)book;
/**
 * 书籍是否已经下载到本地
 * @param book  书本对象
 * @return  书本已经下载过则返回true，否则返回false
 * @see Book
 */
- (BOOL) isBookDownloaded:(BookEntity *)book;

/**
 * 阅读书籍
 * @param book 
 * @param UINavigationController  viewController
 * @return void
 */
- (void) readBook:(BookEntity *)book useNavigation:(UINavigationController*)navigationController;

- (BOOL)bookPressed:(BookEntity*)book useNavigation:(UINavigationController *)navigation;
- (BOOL)bookPressedCheckDownload:(BookEntity*)book useNavigation:(UINavigationController *)navigation;

- (DownloadEntity *)getCoreDataDownload:(NSString *)url;

- (NSMutableArray *)getLocalBooks;

- (BOOL) deleteLocalBooks:(NSMutableArray *)books;

- (void) setManagedObjectContext:(NSManagedObjectContext *) moContext;

@end
