//
//  TableSecitonDataObject.h
//  magicEnglish
//
//  Created by libin.tian on 9/16/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableSecitonDataObject : NSObject

@property (nonatomic, copy) NSString* sectionTitle;
@property (nonatomic, strong) NSMutableArray* itemArray;

@end
