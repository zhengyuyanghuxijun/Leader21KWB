//
//  DownloadItem.h
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "Leader21SDKOC.h"

#define kDownloadItemStateChanaged @"DownloadItemStateChanged"
#define kDownloadItemProgressChanged @"DownloadItemProgressChanged"

@interface DownloadItem : ASIHTTPRequest<ASIProgressDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,assign)DownloadItemState downloadState;
@property(nonatomic,retain)NSString *downloadStateDescription;
@property(nonatomic,retain)NSDate *createDate;
@property(nonatomic,assign)double receivedLength;
@property(nonatomic,assign)double totalLength;
@property(nonatomic,assign)double downloadPercent;
@property(nonatomic,copy)void(^DownloadItemStateChangedCallback)(DownloadItem *callbackItem);
@property(nonatomic,copy)void(^DownloadItemProgressChangedCallback)(DownloadItem *callbackItem);
@property (nonatomic, assign) BOOL isFree;

-(void)startDownloadTask;
-(void)pauseDownloadTask;
-(void)cancelDownloadTask;

+(NSString *)getDownloadStateDescriptionFromState:(DownloadItemState)state;

@end
