//
//  ShoppingCartUtil.h
//  magicEnglish
//
//  Created by tianlibin on 14-4-6.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookEntity;


@interface ShoppingCartUtil : NSObject

+ (NSInteger)shoppingCartListCount;
+ (CGFloat)fullPriceForShoppingCart;
+ (BOOL)isInShoppingCart:(NSString*)bookId;

+ (BOOL)addToShoppingCart:(BookEntity*)book;
+ (BOOL)removeFromShoppingCart:(BookEntity*)book;

+ (BOOL)cleanShoppingCart;

@end
