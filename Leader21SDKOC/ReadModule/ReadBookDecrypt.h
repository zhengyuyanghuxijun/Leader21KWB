//
//  ReadBookDecrypt.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-27.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadBookDecrypt : NSObject

DEC_SINGLETON(ReadBookDecrypt);

@property (nonatomic, strong, readonly) NSMutableDictionary *decryptFiles;

- (void)decryptAllFile:(NSString *)bookIndexName isBookFree:(BOOL)isBookFree;

@end
