//
//  HBMyWorkViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyWorkViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBMyWorkView.h"
#import "HBScoreView.h"

#import "HBServiceManager.h"
#import "HBTaskEntity.h"
#import "HBTestWorkManager.h"

@interface HBMyWorkViewController () <HBMyWorkViewDelegate>
{
    UIProgressView *_progressView;
    HBMyWorkView *_myWorkView;
    HBTitleView *_labTitle;
}

@property (nonatomic, strong)NSMutableArray *scoreArray;

@end

@implementation HBMyWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _labTitle = [HBTitleView titleViewWithTitle:_taskEntity.bookName onView:self.view];
    [self.view addSubview:_labTitle];
    
    [self addBackButton];
    
    [self initUI];
}

- (void)initUI
{
    CGRect rect = self.view.frame;
    float controlX = 20;
    float controlY = KHBNaviBarHeight + 30;
    float controlW = rect.size.width - controlX*2;
    CGRect viewFrame = CGRectMake(controlX, controlY, controlW, 10);
    _progressView = [[UIProgressView alloc] initWithFrame:viewFrame];
    _progressView.trackTintColor = RGBCOLOR(216, 212, 202);
    _progressView.progressTintColor = [UIColor colorWithHex:0xff8903];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    _progressView.transform = transform;
    [self.view addSubview:_progressView];
    
    controlX = 0;
    controlY = CGRectGetMaxY(_progressView.frame) + 30;
    controlW = rect.size.width;
    float controlH = rect.size.height - controlY;
    _myWorkView = [[HBMyWorkView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _myWorkView.delegate = self;
    _myWorkView.workManager = self.workManager;
    NSDictionary *dict = [_workManager getQuestion:0];
    [self updateWorkData:dict];
    [self.view addSubview:_myWorkView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWorkData:(NSDictionary *)dict
{
    if (_scoreArray) {
//        [_scoreArray removeAllObjects];
    } else {
        self.scoreArray = [[NSMutableArray alloc] init];
    }
    if (dict) {
        [_myWorkView updateData:dict byScore:_taskEntity.score];
    }
}

- (void)onTouchFinishedButton
{
    //更新进度条
    NSInteger index = _workManager.selIndex;
    NSInteger total = [_workManager.workArray count]-1;
    _progressView.progress = ((double)index+1) / total;
    //统计成绩
    [self handleScore];
    
    //下一题或者完成
    NSDictionary *dict = [_workManager nextQuestion];
    if (dict) {
        [self updateWorkData:dict];
    } else {
        //提交成绩，算分数
        if (_taskEntity.score) {
            [self showScoreView];
        } else {
            
        }
    }
}

- (void)showScoreView
{
    _progressView.hidden = YES;
    _myWorkView.hidden = YES;
    _labTitle.text = @"成绩展示";
    
    NSInteger scoreNum = 0;
    for (NSDictionary *dict in _scoreArray) {
        BOOL isRight = [dict[@"score"] boolValue];
        if (isRight) {
            NSInteger num = [dict[@"scoreNum"] integerValue];
            scoreNum += num;
        }
    }
    
    CGRect frame = _myWorkView.frame;
    HBScoreView *scoreView = [[HBScoreView alloc] initWithFrame:frame score:scoreNum];
    [scoreView.finishBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreView];
}

- (void)buttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitScore
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
//    [[HBServiceManager defaultManager] requestSubmitScore:userEntity.name book_id:<#(NSInteger)#> bookset_id:<#(NSInteger)#> exam_id:<#(NSInteger)#> question_stat:<#(NSString *)#> completion:<#^(id responseObject, NSError *error)receivedBlock#>]
}

- (void)handleScore
{
    NSDictionary *dict = [_workManager currentQuestion];
    NSMutableDictionary *scoreDict = [[NSMutableDictionary alloc] init];
    [scoreDict setObject:dict[@"Type"] forKey:@"type"];
    [scoreDict setObject:dict[@"Knowledge"] forKey:@"knowledge"];
    [scoreDict setObject:dict[@"Ability"] forKey:@"ability"];
    [scoreDict setObject:dict[@"Difficulty"] forKey:@"difficulty"];
    [scoreDict setObject:dict[@"Score"] forKey:@"scoreNum"];
    BOOL isRight = [_myWorkView isQuestionRight:[dict[@"Answer"] integerValue]];
    [scoreDict setObject:@(isRight) forKey:@"score"];
    
    [_scoreArray addObject:scoreDict];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
