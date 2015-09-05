//
//  ReadBookHighlightShower.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-7.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenReaderObject.h"

@interface ReadBookHighlightShower : NSObject

DEC_SINGLETON(ReadBookHighlightShower);

- (void)setView:(UIView *)view blockObject:(BlockObject *)blockObj;
- (void)setView:(UIView *)view flowObject:(FlowObject *)flowObject currentPlayTime:(NSTimeInterval)currentTime;
- (void)cleanHighlightView;

@end
