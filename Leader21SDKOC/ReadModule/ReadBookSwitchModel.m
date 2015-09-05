//
//  ReadBookSwitchObject.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-5.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookSwitchModel.h"

@implementation ReadBookSwitchObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isAutoPlayEnable forKey:@"isAutoPlayEnable"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.isAutoPlayEnable = [aDecoder decodeBoolForKey:@"isAutoPlayEnable"];
    }
    return self;
}

@end

@interface ReadBookSwitchModel()

@property (nonatomic, retain) ReadBookSwitchObject *switchObject;

@end

@implementation ReadBookSwitchModel

DEF_SINGLETON(ReadBookSwitchModel)

#define SWITCH_ARCHIVE_KEY @"switchObject"

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (BOOL)isAutoPlayEnable
{
    return self.switchObject.isAutoPlayEnable;
}

- (void)setAutoPlayEnable:(BOOL)isEnable
{
    if (!self.switchObject) {
        self.switchObject = [[ReadBookSwitchObject alloc] init];
    }
    self.switchObject.isAutoPlayEnable = isEnable;
}

- (ReadBookSwitchObject *)switchObject
{
    if (_switchObject == nil) {
        NSData *switchData = [[NSUserDefaults standardUserDefaults] objectForKey:SWITCH_ARCHIVE_KEY];
        if (switchData) {
            _switchObject = [NSKeyedUnarchiver unarchiveObjectWithData:switchData];
        }
        else{
            _switchObject = [[ReadBookSwitchObject alloc] init];
        }
    }
    return _switchObject;
}

- (void)enterBackground:(NSNotification *)notification
{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self.switchObject];
    if (archiveData) {
        [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:SWITCH_ARCHIVE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
