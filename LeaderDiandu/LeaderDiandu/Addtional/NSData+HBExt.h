//
//  NSData+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

//MD5加密
@interface NSData (MD5)

- (NSData*) MD5;

@end



//SHA加密
@interface NSData (SHA)

- (NSData*) SHA1;
- (NSData*) SHA256;

@end