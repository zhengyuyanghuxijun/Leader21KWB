//
//  HBMyWorkViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyWorkViewController.h"
#import "HBMyWorkView.h"
#import "HBScoreView.h"
#import "HHAlertSingleView.h"

#import "HBServiceManager.h"
#import "HBTaskEntity.h"
#import "HBTestWorkManager.h"

@interface HBMyWorkViewController () <HBMyWorkViewDelegate>
{
    UIProgressView *_progressView;
    HBMyWorkView *_myWorkView;
    
    NSInteger _scoreNum;
}

@property (nonatomic, strong)NSMutableArray *scoreArray;

@property (nonatomic, assign)NSInteger fromTime;
@property (nonatomic, assign)NSInteger toTime;

@end

@implementation HBMyWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scoreNum = 0;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = _taskEntity.bookName;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self initUI];
    
    NSDate *date = [NSDate date];
    self.fromTime = [date timeIntervalSince1970];
}

- (void)initUI
{
    CGRect rect = self.view.frame;
    float controlX = 20;
    NSInteger margin = 30;
    if ([[UIDevice currentDevice] isIphone5]) {
        margin = 10;
    }
    float controlY = KHBNaviBarHeight + margin;
    float controlW = rect.size.width - controlX*2;
    CGRect viewFrame = CGRectMake(controlX, controlY, controlW, 10);
    _progressView = [[UIProgressView alloc] initWithFrame:viewFrame];
    _progressView.trackTintColor = RGB(216, 212, 202);
    _progressView.progressTintColor = [UIColor colorWithHex:0xff8903];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    _progressView.transform = transform;
    [self.view addSubview:_progressView];
    
    controlX = 0;
    controlY = CGRectGetMaxY(_progressView.frame) + margin;
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
    NSInteger total = [_workManager.workArray count];
    _progressView.progress = ((double)index+1) / (total-1);
    //统计成绩
    [self handleScore];
    
    //下一题或者完成
    NSDictionary *dict = [_workManager nextQuestion];
    if (dict) {
        [self updateWorkData:dict];
    } else {
        //替换成百分制
        _scoreNum = _scoreNum*10/total;
        //提交成绩，算分数
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        //老师和教研员不需要提交成绩
        if ([_taskEntity.score length] > 0 || userEntity.type>1) {
            [self showScoreView];
        } else {
            [self submitScore];
        }
    }
}

- (void)showScoreView
{
    _progressView.hidden = YES;
    _myWorkView.hidden = YES;
    self.title = @"成绩展示";
    
    CGRect frame = _myWorkView.frame;
    if (iPhone4 || [UIDevice isiPad]) {
        frame.origin.y = CGRectGetMinY(_progressView.frame);
        frame.size.height = CGRectGetMaxY(_myWorkView.frame) - frame.origin.y;
    }
    HBScoreView *scoreView = [[HBScoreView alloc] initWithFrame:frame score:_scoreNum];
    [scoreView.finishBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreView];
}

- (void)buttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonPressed:(id)sender
{
    if ([_scoreArray count] < [_workManager.workArray count]) {
        [MBHudUtil showTextAlert:@"提示" msg:@"作业没有完成，确定要现在退出吗？" delegate:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)submitScore
{
    NSDate *date = [NSDate date];
    self.toTime = [date timeIntervalSince1970];
    
    NSString *jsonStr = nil;
    if ([_scoreArray count] > 0) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_scoreArray options:NSJSONWritingPrettyPrinted error:&error];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        [MBHudUtil showTextViewAfter:@"作业提交失败，请重新提交"];
        return;
    }
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [MBHudUtil showActivityView:@"正在提交" inView:nil];
    [[HBServiceManager defaultManager] requestSubmitScore:userEntity.name book_id:_taskEntity.bookId exam_id:_taskEntity.exam_id score:_scoreNum fromTime:_fromTime toTime:_toTime question_stat:jsonStr completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        NSString *result = [responseObject stringForKey:@"result"];
        if ([result isEqualToString:@"OK"]) {
            [self showScoreView];
        } else {
            [MBHudUtil showTextViewAfter:@"作业提交失败，请重新提交"];
        }
    }];
}

- (void)handleScore
{
    NSDictionary *dict = [_workManager currentQuestion];
    NSMutableDictionary *scoreDict = [[NSMutableDictionary alloc] init];
    [scoreDict setObject:dict[@"Type"] forKey:@"type"];
    [scoreDict setObject:dict[@"Knowledge"] forKey:@"knowledge"];
    [scoreDict setObject:dict[@"Ability"] forKey:@"ability"];
    [scoreDict setObject:dict[@"Difficulty"] forKey:@"difficulty"];
    BOOL isRight = [_myWorkView isQuestionRightByDict:dict];
    [scoreDict setObject:@(isRight) forKey:@"score"];
    if (isRight) {
        NSInteger num = [dict[@"Score"] integerValue];
        _scoreNum += num;
    }
    
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
