//
//  HBContentManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentManager.h"
#import "HBContentBaseRequest.h"

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
    [dict setObject:KAppKeyStudy forKey:KWBAppKey];
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

- (void)requestUpdateBookProgress:(NSString *)user book_id:(NSInteger)book_id progress:(NSInteger)progress completion:(HBContentReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"boouserk_id"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    [dicInfo setObject:@(progress)     forKey:@"progress"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/book/progress/update" dict:dicInfo block:receivedBlock];
}

- (void)requestBookProgress:(NSString *)user book_id:(NSInteger)book_id completion:(HBContentReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"boouserk_id"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/book/progress" dict:dicInfo block:receivedBlock];
}

- (void)requestBookProgress:(NSString *)user bookset_id:(NSInteger)bookset_id completion:(HBContentReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"boouserk_id"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/bookset/progress" dict:dicInfo block:receivedBlock];
}

@end
