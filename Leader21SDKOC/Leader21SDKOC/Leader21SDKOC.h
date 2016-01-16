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

//解压书籍block，bookDir为空时解压失败，需要重新下载书籍
typedef void (^UnzipBookBlock)(NSString *bookDir);

@interface Leader21SDKOC : NSObject

+ (Leader21SDKOC *)sharedInstance;

/**设置服务器地址
 @param hostUrl 服务器地址
 */
- (void)setServerUrl:(NSString *)serverUrl;

/**设置app的appKey，此appKey从leader21网站获取
 @param appKey leader21 appKey
 */
- (void)setAppKey:(NSString *)appKey;

/*
 *  从数据库里面获取存储的书籍。
 */
- (NSArray *)getAllStoredBooks;

/* 解压书籍
 * @param path 书籍压缩包路径，可以传空，为默认下载路径
 * @param book 一本书
 * @param block 解压回调block
 * @return
 */
- (void)unzipBookByPath:(NSString *)path entity:(BookEntity *)book block:(UnzipBookBlock)block;

/**根据bookId获取book的详细信息
 @param bookIds bookId列表
        block： 回调，返回书本详细信息
 */
- (void)requestBookInfo:(NSString *)bookIds
              onComplete:(ResponseBookListBlock)block;

/**根据bookId下载一本book
 @param bookId bookId
 监听下载信息，注册
 [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateProgress:)
            name:kNotification_bookDownloadProgress
            object:nil];
 */
- (void)startDownloadBook:(BookEntity *)book;
- (void)startDownloadBookByDict:(NSDictionary *)dict;
/**
 * 暂停下载
 * @param book
 */
- (void)pauseDownload:(BookEntity *)book;
- (void)pauseAllDownloadTask;

/**
 * 取消下载
 * @param book
 */
- (void)cancelDownload:(BookEntity *)book;

/**
 * 书籍是否正在下载
 * @param book
 * @return 如正在下载，返回true，否则返回false
 */
- (BOOL)isBookDownloading:(BookEntity *)book;
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
- (void)readBook:(BookEntity *)book useNavigation:(UINavigationController*)navigationController;

- (BOOL)bookPressed:(BookEntity*)book useNavigation:(UINavigationController *)navigation;
- (BOOL)bookPressedCheckDownload:(BookEntity*)book useNavigation:(UINavigationController *)navigation;

// TODO 暂留，原则上不需要
- (DownloadEntity *)getCoreDataDownload:(NSString *)url;

/**
 * 获取本地书籍
 * @param
 * @return 本地书籍数组
 */
- (NSMutableArray *)getLocalBooks;

/**
 * 删除几本书，删除之后需要重新调用getAllStoredBooks获取书籍数组
 * @param books 书的数组
 * @return 删除成功返回YES，失败返回NO
 */
- (BOOL) deleteLocalBooks:(NSMutableArray *)books;

- (void) setManagedObjectContext:(NSManagedObjectContext *) moContext;

@end
