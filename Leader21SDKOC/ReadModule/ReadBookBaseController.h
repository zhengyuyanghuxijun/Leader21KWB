//
//  ReadBookBaseController.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-14.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBaseObject.h"
#import "ReadBookContentViewController.h"
#import "ReadBookResourceFactory.h"
#import "ReadBookPlayer.h"
#import "ReadBookLocationConverter.h"
#import "ReadBookViewController.h"
#import "ReadBookContentViewController.h"

#define ICON_STAR               @"star.swf"
#define ICON_ARROW              @"block_arrow.swf"
#define ICON_ARROW_SERIERS      @"block_arrow_series.swf"
#define ICON_FLYING_ARROW       @"flying_arrow.swf"
#define ICON_QUESTION_MARK      @"question_mark.swf"

#define HIGHLIGHT_UNDERLINE     @"underline.swf"
#define HIGHLIGHT_RECTANGLE     @"drawn_rectangle.swf"
#define HIGHLIGHT_CIRCLE        @"drawn_circle.swf"
#define HIGHLIGHT_HIGHLIGHT     @"highlight.swf"

@interface IconViewObject : NSObject

@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) IconObject *iconObj;

@end

@interface HighlightViewObject : NSObject

@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) HighlightObject *highlightObj;

@end

@interface AnimationObject : NSObject

@property (nonatomic, strong) NSMutableArray *contentViewArr;
@property (nonatomic, strong) NSString *indexName;
@property (nonatomic, strong) ModelBaseObject *modelBaseObj;

@end

@protocol ReadBookBaseControllerDelegate

@optional
- (void)voicePlayFinish;
- (NSData *)prepareVoiceData:(NSString *)xmlObjName indexName:(NSString *)indexName;

@end

@interface ReadBookBaseController : NSObject<ReadBookBaseControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *aniDic;
@property (nonatomic, strong) NSMutableArray *animatingIconArray;
@property (nonatomic, strong) NSMutableArray *animatingHighlightArray;
@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, weak) ReadBookViewController *readBookViewController;

- (void)setModelBaseObj:(ModelBaseObject *)modelBaseObj
              indexName:(NSString *)indexName
          contentViewVC:(ReadBookContentViewController *)contentViewVC;

- (void)doWithTime:(NSTimeInterval)currentTime
   animationObject:(AnimationObject *)aniObj;
- (void)readModelChange;
- (void)stopPlay;

@end
