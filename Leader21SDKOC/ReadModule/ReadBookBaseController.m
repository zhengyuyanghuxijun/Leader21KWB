//
//  ReadBookBaseController.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-14.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookBaseController.h"

//#define STAR_FACTOR             ([DE isPad]?1.4f:0.67f)
//#define FLYING_FACTOR           ([DE isPad]?1.4f:0.67f)

#define STAR_FACTOR             ([DE isPad]?2.0f:0.8f)
#define FLYING_FACTOR           ([DE isPad]?2.0f:1.0f)
#define ARROR_FACTOR            ([DE isPad]?2.2f:1.2f)
#define QUESTION_MASK_FACTOR    ([DE isPad]?1.4f:0.67f)

@implementation IconViewObject

@end

@implementation HighlightViewObject

@end

@implementation AnimationObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentViewArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@interface ReadBookBaseController()

@property (nonatomic, strong) ReadBookPlayer *readBookPlayer;

@end

@implementation ReadBookBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aniDic = [[NSMutableDictionary alloc] init];
        self.animatingHighlightArray = [[NSMutableArray alloc] init];
        self.animatingIconArray = [[NSMutableArray alloc] init];
        self.readBookPlayer = [[ReadBookPlayer alloc] init];
    }
    return self;
}

- (void)readModelChange
{
    
    [self.animationView setFrame:self.readBookViewController.pageViewController.view.frame];
    [self.readBookViewController.view addSubview:self.animationView];
    [self.readBookViewController.view bringSubviewToFront:self.animationView];
    [self.readBookViewController.view bringSubviewToFront:self.readBookViewController.readBookToolBar];
    [self.readBookViewController.view bringSubviewToFront:self.readBookViewController.rotateButton];
}

- (void)setModelBaseObj:(ModelBaseObject *)modelBaseObj
              indexName:(NSString *)indexName
          contentViewVC:(ReadBookContentViewController *)contentViewVC
{
    AnimationObject *aniObj = [self.aniDic objectForKey:modelBaseObj.name];
    if (aniObj) {
        [aniObj.contentViewArr addObject:contentViewVC];
    }
    else
    {
        aniObj = [[AnimationObject alloc] init];
        aniObj.modelBaseObj = modelBaseObj;
        aniObj.indexName = indexName;
        [aniObj.contentViewArr addObject:contentViewVC];
        [self.aniDic setObject:aniObj forKey:modelBaseObj.name];
    }
    [self checkBegin:modelBaseObj.name];
}

- (void)checkBegin:(NSString *)xmlObjName
{
    AnimationObject *aniObj = [self.aniDic objectForKey:xmlObjName];
    NSMutableString *tempName = [NSMutableString stringWithString:@""];
    for (ReadBookContentViewController *contentVC in aniObj.contentViewArr) {
        if ([tempName isEqualToString:@""]) {
            [tempName appendString:contentVC.contentImageName];
        }
        else
        {
            [tempName appendString:[NSString stringWithFormat:@"-%@",contentVC.contentImageName]];
        }
        if ([tempName isEqualToString:xmlObjName]) {
            [self startPlay:xmlObjName];
        }
    }
}

- (void)startPlay:(NSString *)xmlObjName
{
    AnimationObject *ocAniObj = [self.aniDic objectForKey:xmlObjName];
    __weak ReadBookBaseController *wSelf = self;
    if (ocAniObj) {
        if ([wSelf respondsToSelector:@selector(prepareVoiceData:indexName:)]) {
            NSData *data = [self prepareVoiceData:xmlObjName indexName:ocAniObj.indexName];
            if (data) {
                [self.readBookPlayer stopRead];
                [self.readBookPlayer setTimeUpdateBlock:^(NSTimeInterval currentTime, BOOL isPlayFinish){
                    [wSelf doWithTime:currentTime animationObject:ocAniObj];
                    if (isPlayFinish) {
                        if ([wSelf respondsToSelector:@selector(voicePlayFinish)]) {
                            [wSelf voicePlayFinish];
                        }
                    }
                }];
                [self.readBookPlayer playReadBookVoice:data];
            }
            else
            {
                NSLog(@"Error Data Source is %@ , xmlObjName is %@,ocAniObj.indexName is %@",data,xmlObjName,ocAniObj.indexName);
            }
        }
    }
}

- (void)doWithTime:(NSTimeInterval)currentTime animationObject:(AnimationObject *)aniObj
{
    
    [self cleanExpireIconView:currentTime];
    for (IconObject *iconObj in [aniObj modelBaseObj].iconsArray) {
        if ([iconObj start].floatValue < currentTime * 1000 &&
            [iconObj end].floatValue > currentTime * 1000)
        {
            [self doIconAnimation:iconObj animationObject:aniObj currentTime:currentTime];
        }
    }
    
    [self cleanExpireHighlightView:currentTime];
    for (HighlightObject *highlightObject in [aniObj modelBaseObj].highlightsArray) {
        if ([highlightObject start].floatValue < currentTime * 1000 &&
            [highlightObject end].floatValue > currentTime * 1000)
        {
            [self doHighlightAnimation:highlightObject animationObject:aniObj currentTime:currentTime];
        }
    }
}

- (void)cleanExpireIconView:(NSTimeInterval)currentTime
{
    NSMutableArray *iconDelArray = [NSMutableArray array];
    for (IconViewObject *iconViewObj in self.animatingIconArray) {
        if ([[iconViewObj iconObj] start].floatValue > currentTime * 1000 ||
            [[iconViewObj iconObj] end].floatValue < currentTime * 1000)
        {
            [iconViewObj.iconView removeFromSuperview];
            [iconDelArray addObject:iconViewObj];
        }
    }
    if (iconDelArray && iconDelArray.count > 0) {
        [self.animatingIconArray removeObjectsInArray:iconDelArray];
    }
}

- (void)cleanExpireHighlightView:(NSTimeInterval)currentTime
{
    NSMutableArray *highlightDelArray = [NSMutableArray array];
    for (HighlightViewObject *highlightViewObject in self.animatingHighlightArray) {
        if ([[highlightViewObject highlightObj] start].floatValue > currentTime * 1000 ||
            [[highlightViewObject highlightObj] end].floatValue < currentTime * 1000)
        {
            [highlightViewObject.highlightView removeFromSuperview];
            [highlightDelArray addObject:highlightViewObject];
        }
    }
    if (highlightDelArray && highlightDelArray.count > 0) {
        [self.animatingHighlightArray removeObjectsInArray:highlightDelArray];
    }
}

- (void)doIconAnimation:(IconObject *)iconObj animationObject:(AnimationObject *)aniObj currentTime:(NSTimeInterval)currentTime
{
    if (iconObj == nil) {
        return;
    }
    
    BOOL isContained = NO;
    for (IconViewObject *iconViewObj in self.animatingIconArray) {
        if ([iconViewObj.iconObj isEqual:iconObj]) {
            isContained = YES;
            break;
        }
    }
    
    if (!isContained) {
        [self createIconAniView:iconObj animationObject:aniObj];
    }
}

- (void)doHighlightAnimation:(HighlightObject *)highlightObj animationObject:(AnimationObject *)aniObj currentTime:(NSTimeInterval)currentTime
{
    if (highlightObj == nil) {
        return;
    }
    BOOL isContained = NO;
    for (HighlightViewObject *highlightViewObject in self.animatingHighlightArray){
        if ([highlightViewObject.highlightObj isEqual:highlightObj]) {
            isContained = YES;
            break;
        }
    }
    if (!isContained) {
        [self createHighlightAniView:highlightObj animationObject:aniObj];
    }
}

- (void)createIconAniView:(IconObject *)iconObj animationObject:(AnimationObject *)aniObj
{
    CGPoint sourcePoint = CGPointMake([iconObj x].floatValue, [iconObj y].floatValue);
    CGPoint targetPoint = [ReadBookLocationConverter splitLocationConverterPoint:sourcePoint
                                                                      targetView:self.animationView];
    UIImageView *iconView = nil;
    if ([iconObj.url isEqualToString:ICON_STAR])
    {
        targetPoint.x+=10 ;
        targetPoint.y+=10;
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        iconView.frame = CGRectMake(targetPoint.x, targetPoint.y, iconView.width * [iconObj scale].floatValue * STAR_FACTOR, iconView.height * [iconObj scale].floatValue * STAR_FACTOR);
        [self.animationView addSubview:iconView];
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation1.fromValue = [NSNumber numberWithFloat:0.0];
        animation1.toValue = [NSNumber numberWithFloat:M_PI * 4];
        
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation2.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:1.0], nil];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 1.0;
        group.repeatCount = 1;
        group.animations = [NSArray arrayWithObjects:animation1, animation2, nil];
        
        [iconView.layer addAnimation:group forKey:@"move-rotate-layer"];
    }
    else if ([iconObj.url isEqualToString:ICON_ARROW] || [iconObj.url isEqualToString:ICON_ARROW_SERIERS])
    {
        
        targetPoint.x-=8;
        targetPoint.y+=5;
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_arrow"]];
        iconView.frame = CGRectMake(targetPoint.x, targetPoint.y, iconView.width * [iconObj scale].floatValue * ARROR_FACTOR, iconView.height * [iconObj scale].floatValue * ARROR_FACTOR);
        
        [iconView setTransform: CGAffineTransformMakeRotation(([iconObj rotation].floatValue/180 * M_PI))];
        [self.animationView addSubview:iconView];
        
        NSInteger moveDistance = 40.0f;
        [UIView animateWithDuration:0.5f animations:^{
            CGFloat nx = iconView.center.x  + cos([iconObj rotation].floatValue/180 * M_PI) * moveDistance;
            CGFloat ny = iconView.center.y  + sin([iconObj rotation].floatValue/180 * M_PI) * moveDistance;
            iconView.center = CGPointMake(nx, ny);
        }];
    }
    else if ([iconObj.url isEqualToString:ICON_FLYING_ARROW])
    {
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flying_arrow"]];
        iconView.frame = CGRectMake(targetPoint.x, targetPoint.y, iconView.width * [iconObj scale].floatValue * FLYING_FACTOR, iconView.height * [iconObj scale].floatValue * FLYING_FACTOR);
        [iconView setTransform: CGAffineTransformMakeRotation(([iconObj rotation].floatValue/180 * M_PI))];
        [self.animationView addSubview:iconView];
        
        NSInteger moveDistance = 40.0f;
        [UIView animateWithDuration:0.5f animations:^{
            CGFloat nx = iconView.center.x  + cos([iconObj rotation].floatValue/180 * M_PI) * moveDistance;
            CGFloat ny = iconView.center.y  + sin([iconObj rotation].floatValue/180 * M_PI) * moveDistance;
            iconView.center = CGPointMake(nx, ny);
        }];
    }
    else if ([iconObj.url isEqualToString:ICON_QUESTION_MARK])
    {
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_mark"]];
        iconView.frame = CGRectMake(targetPoint.x, targetPoint.y, iconView.width * [iconObj scale].floatValue * QUESTION_MASK_FACTOR, iconView.height * [iconObj scale].floatValue * QUESTION_MASK_FACTOR);
        [iconView setTransform: CGAffineTransformMakeRotation(([iconObj rotation].floatValue/180 * M_PI))];
        [self.animationView addSubview:iconView];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:1.0], nil];
        animation.duration = 1.0;
        animation.repeatCount = 1;
        [iconView.layer addAnimation:animation forKey:@"scale"];
    }
    
    if(iconView)
    {
        IconViewObject *iconViewObj = [[IconViewObject alloc] init];
        iconViewObj.iconObj = iconObj;
        iconViewObj.iconView = iconView;
        [self.animatingIconArray addObject:iconViewObj];
    }
}

- (void)createHighlightAniView:(HighlightObject *)highlightObj animationObject:(AnimationObject *)aniObj
{
    CGPoint sourcePoint = CGPointMake([highlightObj x].floatValue, [highlightObj y].floatValue);
    CGPoint targetPoint = [ReadBookLocationConverter splitLocationConverterPoint:sourcePoint
                                                                      targetView:self.animationView];
    
    CGSize sourceSize = CGSizeMake([highlightObj width].floatValue, [highlightObj height].floatValue);
    CGSize targetSize = [ReadBookLocationConverter sizeConvert:sourceSize
                                                    targetView:self.animationView];
    
    UIImageView *highlightView = nil;
    if ([highlightObj.url isEqualToString:HIGHLIGHT_UNDERLINE])
    {
        highlightView = [[UIImageView alloc] initWithImage:[UIImage resizebleImageNamed:@"underline"]];
        highlightView.frame = CGRectMake(targetPoint.x, targetPoint.y, targetSize.width , targetSize.height);
        [self.animationView addSubview:highlightView];
    }
    else if ([highlightObj.url isEqualToString:HIGHLIGHT_RECTANGLE])
    {
        highlightView = [[UIImageView alloc] initWithImage:[UIImage resizebleImageNamed:@"drawn_rectangle"]];
        highlightView.frame = CGRectMake(targetPoint.x, targetPoint.y, targetSize.width , targetSize.height);
        [self.animationView addSubview:highlightView];
    }
    else if ([highlightObj.url isEqualToString:HIGHLIGHT_CIRCLE])
    {
        highlightView = [[UIImageView alloc] initWithImage:[UIImage resizebleImageNamed:@"drawn_oval"]];
        highlightView.frame = CGRectMake(targetPoint.x, targetPoint.y, targetSize.width , targetSize.height);
        [self.animationView addSubview:highlightView];
    }
    else if ([highlightObj.url isEqualToString:HIGHLIGHT_HIGHLIGHT])
    {
        highlightView = [[UIImageView alloc] initWithImage:[UIImage resizebleImageNamed:@"highlight"]];
        highlightView.frame = CGRectMake(targetPoint.x, targetPoint.y, targetSize.width , targetSize.height);
        [self.animationView addSubview:highlightView];

        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0], nil];
        [highlightView.layer addAnimation:animation forKey:@"trans-opacity"];
    }
    
    if (highlightView)
    {
        HighlightViewObject *highlightViewObject = [[HighlightViewObject alloc] init];
        highlightViewObject.highlightObj = highlightObj;
        highlightViewObject.highlightView = highlightView;
        [self.animatingHighlightArray addObject:highlightViewObject];
    }
}

- (void)stopPlay
{
    for (HighlightViewObject *highlightViewObject in self.animatingHighlightArray) {
        [highlightViewObject.highlightView removeFromSuperview];
    }
    for (IconViewObject *iconViewObj in self.animatingIconArray) {
        [iconViewObj.iconView removeFromSuperview];
    }
    [self.animationView removeFromSuperview];
    self.animationView = nil;
    [self.animatingHighlightArray removeAllObjects];
    [self.animatingIconArray removeAllObjects];
    [self.aniDic removeAllObjects];
    self.readBookPlayer.voicePlayingBlock = nil;
    [self.readBookPlayer stopRead];
}

- (UIView *)animationView
{
    if (!_animationView) {
        _animationView = [[UIView alloc] initWithFrame:self.readBookViewController.pageViewController.view.frame];
        _animationView.backgroundColor = [UIColor clearColor];
        _animationView.clipsToBounds = YES;
    }
    return _animationView;
}
@end
