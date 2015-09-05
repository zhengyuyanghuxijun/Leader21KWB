//
//  NSManagedObject+BookEntity.h
//  Leader21SDKOC
//
//  Created by leader on 15/7/1.
//  Copyright (c) 2015年 leader. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DownloadEntity;
@interface BookEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * bookId;
@property (nonatomic, retain) NSString * bookCover;
@property (nonatomic, retain) NSString * bookTitle;
@property (nonatomic, retain) NSString * bookTitleCN;
@property (nonatomic, retain) NSString * fileId;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSNumber * unit;
@property (nonatomic, retain) NSString * theme;
@property (nonatomic, retain) NSNumber * bookSort;
@property (nonatomic, retain) NSString * bookLevel;
@property (nonatomic, retain) NSString * bookType;
@property (nonatomic, retain) NSString * bookSRNO;

//local property
@property (nonatomic, retain) NSString * bookUrl;
@property (nonatomic, retain) NSNumber * hasDown;

@property (nonatomic, retain) DownloadEntity *download;
@end
