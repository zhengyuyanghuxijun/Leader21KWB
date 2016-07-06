//
//  NSDictionary+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//


@interface NSDictionary (String)

//如果找不到，返回@"" (防止出现nil，使程序崩溃)

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

//替换&nbsp;为@" "
- (NSString *)replaceNBSPforKey:(id)aKey ;

@end
