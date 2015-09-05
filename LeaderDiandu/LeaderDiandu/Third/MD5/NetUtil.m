//
//  NetUtil.m
//  FXTool
//
//  Created by 房杨平 on 11-8-26.
//  Copyright 2011 EmatChina. All rights reserved.
//

#import "NetUtil.h"
#import "RC4.h"
#define LOCAL_KEY @"nom:sje!"
#define LOCAL_PRODUCTID @"pd3"

@implementation NetUtil

+ (NSString *) buildOrderWatch:(NSString *)remark currencyPair:(NSString *)pair side:(NSString *)bs customerid:(NSString *)customerid{

	NSString *key = [NSString stringWithFormat:@"%@%@",LOCAL_KEY,remark];
#ifdef DEBUG
	NSLog(@"rc4 --->key = %@",key);
#endif
	RC4 *rc4 = [[RC4 alloc] initWithKey:key];
	NSDate *date = [NSDate date];
	int interval = [date timeIntervalSince1970];
	NSString *keyValue = [NSString stringWithFormat:@"%d,%@,%@,%@,%@",interval,pair,LOCAL_PRODUCTID,bs,customerid];
#ifdef DEBUG
	NSLog(@"rc4 --->keyValue = %@",keyValue);
#endif
    NSString *encodes = [rc4 encryptString:keyValue];
	
	return encodes;
}

@end
