//
//  NSData+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "NSData+HBExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)

- (NSData*) MD5
{
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.bytes, (unsigned int) self.length, output);
    return [NSMutableData dataWithBytes:output length:outputLength];
}

@end



@implementation NSData (SHA)

- (NSData*) SHA1 {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.bytes, (unsigned int) self.length, output);
    return [NSMutableData dataWithBytes:output length:outputLength];
}

- (NSData*) SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.bytes, (unsigned int) self.length, output);
    return [NSMutableData dataWithBytes:output length:outputLength];
}

@end
