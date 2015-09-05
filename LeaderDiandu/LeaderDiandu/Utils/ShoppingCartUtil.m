//
//  ShoppingCartUtil.m
//  magicEnglish
//
//  Created by tianlibin on 14-4-6.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ShoppingCartUtil.h"

#import "BookEntity.h"
#import "ShoppingCartEntity.h"


@implementation ShoppingCartUtil

+ (NSInteger)shoppingCartListCount
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"type == %d", shoppingCartSectionTypeBook];
    NSInteger count = [CoreDataHelper getCountByEntryName:@"ShoppingCartEntity" withPredicate:predicate];
    return count;
}

+ (CGFloat)fullPriceForShoppingCart
{
    CGFloat price = 0.0f;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"type == %d", shoppingCartSectionTypeBook];
    NSArray* array = [CoreDataHelper getAllWithEntryName:@"ShoppingCartEntity" withPredicate:predicate];
    for (ShoppingCartEntity* entity in array) {
        price += entity.book.priceF.floatValue;
    }
    
    return price;
}


+ (BOOL)isInShoppingCart:(NSString*)bookId
{
    if (bookId.length == 0) {
        return NO;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"book.bookId == %@ AND type == %d", bookId, shoppingCartSectionTypeBook];
    id obj = [CoreDataHelper getFirstObjectWithEntryName:@"ShoppingCartEntity" withPredicate:predicate];
    
    if (obj == nil) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (BOOL)addToShoppingCart:(BookEntity*)book
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"book.bookId == %@ AND type == %d", book.bookId, shoppingCartSectionTypeBook];
    ShoppingCartEntity* obj = (ShoppingCartEntity*)[CoreDataHelper getOrCreateEntity:@"ShoppingCartEntity"
                                                                       withPredicate:predicate];
    obj.type = [NSNumber numberWithInteger:shoppingCartSectionTypeBook];
    NSDate* date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long time1 = (long long)time * 1000;
    obj.updateTime = [NSNumber numberWithLongLong:time1];
    obj.book = book;
    
    [CoreDataHelper save];
    
    return YES;
}

+ (BOOL)removeFromShoppingCart:(BookEntity*)book
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"book.bookId == %@ AND type == %d", book.bookId, shoppingCartSectionTypeBook];
    [CoreDataHelper deleteAllWithEntryName:@"ShoppingCartEntity"
                             withPredicate:predicate];
    [CoreDataHelper save];
    return YES;
}

+ (BOOL)cleanShoppingCart
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"type == %d", shoppingCartSectionTypeBook];
    [CoreDataHelper deleteAllWithEntryName:@"ShoppingCartEntity"
                             withPredicate:predicate];
    [CoreDataHelper save];
    return YES;
}


@end
