//
//  HBContentManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentManager.h"
#import "HBContentBaseRequest.h"
#import "AFHTTPRequestOperation.h"
#import "ZipArchive.h"

@interface HBContentManager ()

@property (nonatomic, copy)HBContentReceivedBlock receivedBlock;

@end

@implementation HBContentManager

+ (HBContentManager *)defaultManager
{
    static HBContentManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBContentManager alloc] init];
    });
    return manager;
}

- (void)Post:(NSString *)api dict:(NSMutableDictionary *)dict block:(HBContentReceivedBlock)receivedBlock
{
    [dict setObject:KAppKeyKWB forKey:KWBAppKey];
    [[HBContentBaseRequest requestWithSubUrl:api] startWithMethod:HBHTTPRequestMethodPOST parameters:dict completion:^(id responseObject, NSError *error) {
        if (receivedBlock) {
            receivedBlock(responseObject,error);
        }
    }];
}

- (void)requestBookList:(NSString *)ids completion:(HBContentReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:ids     forKey:@"ids"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/book" dict:dicInfo block:receivedBlock];
}

- (void)requestBookDownload:(NSString *)book_id file_id:(NSString *)file_id completion:(HBContentReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:book_id     forKey:@"book_id"];
    [dicInfo setObject:file_id     forKey:@"file_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/book/download" dict:dicInfo block:receivedBlock];
}

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName completion:(HBDownloadReceiveBlock)block
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    
    //检查文件是否存在，存在的话删除
    if ([fileManager fileExistsAtPath:fileName]) {
        NSError *error;
        [fileManager removeItemAtPath:aSavePath error:&error];
    }
    //创建文件存储目录
    if (![fileManager fileExistsAtPath:aSavePath]) {
        [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:aUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    
    //下载进度控制
    /*
     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
     NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
     }];
     */
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解压文件
        ZipArchive* zip = [[ZipArchive alloc] init];
        
        if ([zip UnzipOpenFile:fileName]) {
            BOOL ret = [zip UnzipFileTo:aSavePath overWrite:YES];
            [zip UnzipCloseFile];
        }
        if (block) {
            block(aSavePath, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //下载失败
        if (block) {
            block(nil, error);
        }
    }];
    
    [operation start];
}

@end
