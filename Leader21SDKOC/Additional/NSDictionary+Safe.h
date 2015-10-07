//
//  NSDictionary+Safe.h
//  magicEnglish
//
//  Created by tianlibin on 14-3-23.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (BOOL)isValidDictionary;

- (NSString*)stringForKey:(NSString*)key;
- (NSNumber*)numberForKey:(NSString*)key;
- (NSDictionary*)dicForKey:(NSString*)key;
- (NSArray*)arrayForKey:(NSString*)key;

- (NSString*)stringForKey:(NSString*)key defautValue:(NSString*)value;
- (NSNumber*)numberForKey:(NSString*)key defautValue:(NSNumber*)value;
- (NSDictionary*)dicForKey:(NSString*)key defautValue:(NSDictionary*)value;
- (NSArray*)arrayForKey:(NSString*)key defautValue:(NSArray*)value;

- (NSInteger)integerForKey:(NSString*)key;
- (long long)longForKey:(NSString*)key;


@end
