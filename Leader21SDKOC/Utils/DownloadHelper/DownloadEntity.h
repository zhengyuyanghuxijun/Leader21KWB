//
//  DownloadEntity.h
//  magicEnglish
//
//  Created by tianlibin on 7/28/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BookEntity;

@interface DownloadEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * totalSize;
@property (nonatomic, retain) NSString * temporaryFileDownloadPath;
@property (nonatomic, retain) NSString * downloadUrl;
@property (nonatomic, retain) NSString * downloadDestinationPath;
@property (nonatomic, retain) NSNumber * currentSize;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSNumber * isFree;
@property (nonatomic, retain) BookEntity *book;

@end
