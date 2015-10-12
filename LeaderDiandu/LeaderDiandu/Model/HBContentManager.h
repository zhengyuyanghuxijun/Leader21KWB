//
//  HBContentManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HBContentReceivedBlock) (id responseObject, NSError *error);

typedef void(^HBDownloadReceiveBlock)(id responseObject, NSError *error);

@interface HBContentManager : NSObject

+ (HBContentManager *)defaultManager;

/**
 *  获取1到n本书的详细信息
 *  只能获取免费或者本人订阅的套餐中已被推送的书本信息
 *
 *  @param ids             书本ID
 *  @param receivedBlock 回调Block
 */
- (void)requestBookList:(NSString *)ids completion:(HBContentReceivedBlock)receivedBlock;

/**
 *  本接口不直接返回下载内容，而是以重定向的方式返回下载URL
 *
 *  @param book_id             书本ID
 *  @param file_id
 *  @param receivedBlock 回调Block
 */
- (void)requestBookDownload:(NSString *)book_id file_id:(NSString *)file_id completion:(HBContentReceivedBlock)receivedBlock;

/**
 * 下载文件
 *
 * @param string aUrl 请求文件地址
 * @param string aSavePath 保存地址
 * @param string aFileName 文件名
 * @param int aTag tag标识
 */
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName completion:(HBDownloadReceiveBlock)block;

@end
