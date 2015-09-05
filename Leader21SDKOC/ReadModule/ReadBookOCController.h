//
//  ReadBookOCAnimationHelper.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookBaseController.h"
#import "OCXMLObject.h"

@interface ReadBookOCController : ReadBookBaseController

- (void)setOCObj:(OCXMLObject *)ocXMLObj
       indexName:(NSString *)indexName
   contentViewVC:(ReadBookContentViewController *)contentViewVC;

@end
