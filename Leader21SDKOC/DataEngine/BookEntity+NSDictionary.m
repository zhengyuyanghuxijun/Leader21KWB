//
//  BookEntity+NSDictionary.m
//  magicEnglish
//
//  Created by tianlibin on 14-3-17.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "BookEntity+NSDictionary.h"

@implementation BookEntity (NSDictionary)

+ (BookEntity*)itemWithDictionary:(NSDictionary*)dic
{

    NSNumber* bookId = [dic numberForKey:@"ID"];
    BookEntity* entity = nil;
    
    if (bookId != nil) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookId = %d", bookId];
        entity = (BookEntity*)[CoreDataHelper getOrCreateEntity:@"BookEntity" withPredicate:predicate];
    }
    else {
        return entity;
    }
    entity.bookId = bookId;

    entity.bookTitle = [dic stringForKey:@"BOOK_TITLE"];
    entity.bookCover = [dic stringForKey:@"BOOK_COVER"];
    entity.bookTitleCN = [dic stringForKey:@"BOOK_TITLE_CN"];
    entity.fileId = [dic stringForKey:@"FILE_ID"];
    entity.grade = [dic numberForKey:@"GRADE"];
    entity.unit = [dic numberForKey:@"UNIT"];
    entity.theme = [dic stringForKey:@"THEME"];
    entity.bookSort = [dic numberForKey:@"BOOK_SORT"];
    entity.bookLevel = [dic stringForKey:@"BOOK_LEVEL"];
    entity.bookType = [dic stringForKey:@"BOOK_TYPE"];
    entity.bookSRNO = [dic stringForKey:@"BOOK_SRNO"];
    
    return entity;
}

@end
