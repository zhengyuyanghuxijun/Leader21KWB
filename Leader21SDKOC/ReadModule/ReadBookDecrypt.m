//
//  ReadBookDecrypt.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-27.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookDecrypt.h"
#import "ReadBookResourceFileHelper.h"
#import "NSData+CommonCrypto.h"
#import "NSData+Base64.h"


@interface ReadBookDecrypt()

@property (nonatomic, strong, readwrite) NSMutableDictionary *decryptFiles;
@property (nonatomic, strong) NSData *keyData;

@end

typedef ReadBookResourceFileHelper RBHelper;

@implementation ReadBookDecrypt

DEF_SINGLETON(ReadBookDecrypt);

- (id)init
{
    self = [super init];
    if (self) {
        self.decryptFiles = [[NSMutableDictionary alloc] init];
        self.keyData = [NSData base64DataFromString:[self getProcessKey]];
    }
    return self;
}

- (NSString *)getProcessKey
{
    int j = 0;
    int g = 3;
    NSString *i = @"GkNYY+M7L";
    NSString *n = @"hfGU/CyE";
    NSString *z = @"pnw==";
    
    return [NSString stringWithFormat:@"%@%d%@%d%@",i ,j ,n ,g ,z];
}


- (void)decryptAllFile:(NSString *)bookIndexName isBookFree:(BOOL)isBookFree
{
    NSString *currentPath = [NSString stringWithFormat:@"%@/%@",[RBHelper userDocumentPath:isBookFree],bookIndexName];
    NSArray *filesName = [ReadBookResourceFileHelper filesInDoc:currentPath];
    for (NSString *fileName in filesName) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",currentPath,fileName];
        if ([ReadBookResourceFileHelper isFileFolder:filePath]) {
            [self decryptAllFile:[NSString stringWithFormat:@"%@/%@",bookIndexName,fileName] isBookFree:isBookFree];
        }
        else
        {
            [self decryptFile:filePath];
        }
    }
}

- (void)decryptFile:(NSString *)filePath
{
    NSData *initData = [NSData dataWithContentsOfFile:filePath];
    if (initData.length > 0) {
        
        CCCryptorStatus status = kCCSuccess;
        NSData *decryptData = [initData decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:self.keyData options:kCCOptionECBMode error:&status];
        
        if (decryptData && status == kCCSuccess) {
            if ([filePath rangeOfString:@".xml"].location != NSNotFound) {
                NSString *decryptStr = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
                NSRange endRange = [decryptStr rangeOfString:@">" options:NSBackwardsSearch];
                if (endRange.length > 0) {
                    NSString *resStr = [decryptStr substringToIndex:endRange.location + 1];
                    NSData *resData = [resStr dataUsingEncoding:NSUTF8StringEncoding];
                    [resData writeToFile:filePath atomically:YES];
                }
            }
            else if([filePath rangeOfString:@".txt"].location != NSNotFound)
            {
                NSString *decryptStr = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
                NSString *resStr = [decryptStr trimText];
                NSData *resData = [resStr dataUsingEncoding:NSUTF8StringEncoding];
                [resData writeToFile:filePath atomically:YES];
            }
            else
            {
                [decryptData writeToFile:filePath atomically:YES];
            }
        }
        
    }
}

@end
