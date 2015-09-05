//
//  ReadBookContentViewController.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookContentViewController.h"
#import "ReadBookResourceModel.h"
#import "ReadBookLoudSpeaker.h"
#import "ReadBookWordSpeaker.h"
#import "ReadBookPlayer.h"
#import "ReadBookLocationConverter.h"
#import "ReadBookSwitchModel.h"
#import "ReadBookHighlightShower.h"
#import "ReadBookOCController.h"
#import "ReadBookPRController.h"


@interface ReadBookContentViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) UIImageView *contentImageView;
@property (nonatomic, strong) NSMutableArray *loudSpeakerArray;
@property (nonatomic, strong) NSMutableArray *wordSpeakerArray;
@property (nonatomic, strong) ReadBookPlayer *readBookPlayer;
@property (nonatomic, strong) ReadBookHighlightShower *readBookHighlightShower;

@end

@implementation ReadBookContentViewController

- (void)dealloc
{
    [self.loudSpeakerArray removeAllObjects];
    [self.wordSpeakerArray removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.loudSpeakerArray = [[NSMutableArray alloc] init];
        self.wordSpeakerArray = [[NSMutableArray alloc] init];
        self.readBookPlayer = [ReadBookPlayer sharedInstance];
        self.readBookHighlightShower = [[ReadBookHighlightShower alloc] init];
    }
    return self;
}

- (void)setViewFrame:(CGRect)frame
{
    self.view.frame = frame;
    self.contentImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.contentImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.contentImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doCleanHighlightView:)
                                                 name:kNotification_clearPageHightLight
                                               object:nil];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.readBookHighlightShower cleanHighlightView];
    if (self.contentImageName && [self.contentImageName isKindOfClass:[NSString class]]) {
        [self.contentImageView setImage:[self.resourceModel screenReaderImage:self.contentImageName]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadPageData];
}

- (void)reloadPageData
{
    if (self.readType == READ_NORMAL_MODEL || self.readType == READ_SPLIT_MODEL) {
        [self.resourceModel screenReaderObject:self.contentImageName
                               completionBlock:^(ScreenReaderObject *obj) {
                                   [self screenReaderObjectHandle:obj];
                               }];
    }
    else if (self.readType == READ_OC_MODEL)
    {
        [self.resourceModel screenReaderOCObject:self.contentImageName
                                 completionBlock:^(OCXMLObject *obj) {
                                     [self screenReaderOCObjectHandle:obj];
                                 }];
    }
    else if (self.readType == READ_PR_MODEL)
    {
        [self.prController stopPlay];
        [self.prController readModelChange];
        [self.resourceModel screenReaderPRObject:self.contentImageName
                                 completionBlock:^(PRXMLObject *obj) {
                                     [self screenReaderPRObjectHandle:obj];
                                 }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.readBookPlayer stopRead];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];
}

- (void)setContentImageName:(NSString *)contentImageName
{
    if(_contentImageName != contentImageName)
    {
        
        if([contentImageName isEqualToString:@"blank"])
        {
            NSString *indexName = [[[self resourceModel].bookIndexName componentsSeparatedByString:@"/"] lastObject];
            _contentImageName = [NSString stringWithFormat:@"%@_%@",indexName,@"0000"];
        }
        else
        {
            _contentImageName = contentImageName;
        }
    }
}

- (void)screenReaderOCObjectHandle:(OCXMLObject *)ocXMLObject
{
    if (ocXMLObject == nil) {
        return;
    }
    [self.ocController setOCObj:ocXMLObject
                      indexName:[self resourceModel].bookIndexName
                  contentViewVC:self];
}

- (void)screenReaderPRObjectHandle:(PRXMLObject *)prXMLObject
{
    if (prXMLObject == nil) {
        return;
    }
    [self.prController setPRObj:prXMLObject
                      indexName:[self resourceModel].bookIndexName
                  contentViewVC:self];
}

- (void)screenReaderObjectHandle:(ScreenReaderObject *)screenReaderObj
{
    if (screenReaderObj == nil) {
        return;
    }
    
    __weak ReadBookContentViewController *wSelf = self;
    
    for (NSInteger idx = 0; idx < [screenReaderObj flowArray].count; idx++) {
        
        FlowObject *flowObj = [screenReaderObj.flowArray objectAtIndex:idx];
        NSData *voiceData = nil;
        if (flowObj.clip.src) {
            voiceData = [wSelf.resourceModel screenReaderVoiceData:wSelf.contentImageName flowObject:flowObj];
        }
        
        NSString *iconxy = flowObj.iconxy;

        CGPoint locPoint = [ReadBookLocationConverter locationConverter:iconxy targetView:self.contentImageView];
        
        if (!(locPoint.x == -1 && locPoint.y == -1)) {
            
            ReadBookLoudSpeaker *loudSpeaker = [[ReadBookLoudSpeaker alloc] init];
            [loudSpeaker setView:self.contentImageView iconLocation:locPoint loudSpeakerTapBlock:^{
                if (voiceData) {
                    /*
                     [self.readBookPlayer playReadBookVoice:voiceData];
                    /*/
                    [self.readBookPlayer stopRead];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];
                    
                    BlockObject * firstBlock = [flowObj.clip.blocksArray objectAtIndex:0];
                    [wSelf.readBookHighlightShower setView:wSelf.contentImageView blockObject:firstBlock];
                    
                    [self.readBookPlayer addVoiceDataInList:voiceData
                                                 flowObject:flowObj
                                                   voiceTag:self.coupleTag
                                           contentImageView:self.contentImageView];
                        [self.readBookPlayer playVoiceDataInList];
                        [self.readBookPlayer setVoicePlayingBlock:^(FlowObject *flowObject ,NSTimeInterval currentTime, BOOL isFinish,UIImageView *contentImageView){
                            
                            [wSelf.readBookHighlightShower setView:contentImageView
                                                        flowObject:flowObject
                                                   currentPlayTime:currentTime];
                        }];
                    //*/
                    
                    
                }
            }];
            [self.loudSpeakerArray addObject:loudSpeaker];
            
            ReadBookWordSpeaker *wordSpeaker = [[ReadBookWordSpeaker alloc] init];
            [wordSpeaker setView:self.contentImageView
                       blocksArr:flowObj.clip.blocksArray
             wordSpeakerTapBlock:^(float startTime, float endTime, BlockObject *blockObj) {
                 if (voiceData) {
                     
                     [self.readBookPlayer stopRead];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];
                     
                     /*
                     [wSelf.readBookPlayer playReadBookVoice:voiceData atTime:startTime/1000];
                     [wSelf.readBookHighlightShower cleanHighlightView];
                     [wSelf.readBookHighlightShower setView:wSelf.contentImageView blockObject:blockObj];
                     /*/
                     
                     [self.readBookPlayer addVoiceDataInList:voiceData
                                                  flowObject:flowObj
                                                    voiceTag:self.coupleTag
                                            contentImageView:self.contentImageView];
                     [self.readBookPlayer playVoiceDataInList:startTime/1000];
                     [wSelf.readBookHighlightShower setView:wSelf.contentImageView blockObject:blockObj];
                     
                     [self.readBookPlayer setVoicePlayingBlock:^(FlowObject *flowObject ,NSTimeInterval currentTime, BOOL isFinish,UIImageView *contentImageView){
                         
                         [wSelf.readBookHighlightShower setView:contentImageView
                                                     flowObject:flowObject
                                                currentPlayTime:currentTime];
                     }];
                     //*/
                 }
            }];
            [self.wordSpeakerArray addObject:wordSpeaker];
        }
        
        if (voiceData && [[ReadBookSwitchModel sharedInstance] isAutoPlayEnable]) {
            [self.readBookPlayer addVoiceDataInList:voiceData
                                         flowObject:flowObj
                                           voiceTag:self.coupleTag
                                   contentImageView:self.contentImageView];
            if (idx == [screenReaderObj flowArray].count - 1) {
                [self.readBookPlayer playVoiceDataInList];
                [self.readBookPlayer setVoicePlayingBlock:^(FlowObject *flowObject ,NSTimeInterval currentTime, BOOL isFinish,UIImageView *contentImageView){
                    
                    [wSelf.readBookHighlightShower setView:contentImageView
                                                flowObject:flowObject
                                           currentPlayTime:currentTime];
                }];
            }
        }
    }
}

-(void)doCleanHighlightView:(NSNotification*)notification
{
    [self.readBookHighlightShower cleanHighlightView];
}

@end
