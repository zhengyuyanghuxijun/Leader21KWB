//
//  ReadBookSwitchObject.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-5.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadBookSwitchObject : NSObject<NSCoding>

@property (nonatomic, assign) BOOL isAutoPlayEnable;

@end

@interface ReadBookSwitchModel : NSObject

DEC_SINGLETON(ReadBookSwitchModel)

- (BOOL)isAutoPlayEnable;
- (void)setAutoPlayEnable:(BOOL)isEnable;

@end
