//
//  BookEntity+NSDictionary.h
//  magicEnglish
//
//  Created by tianlibin on 14-3-17.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "BookEntity.h"

@interface BookEntity (NSDictionary)

+ (BookEntity*)itemWithDictionary:(NSDictionary*)dic;

@end
