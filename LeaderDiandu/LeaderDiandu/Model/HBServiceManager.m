//
//  HBServiceManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/28.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBServiceManager.h"
#import "HBHTTPBaseRequest.h"
#import "HBDataSaveManager.h"

@interface HBServiceManager ()

@property (nonatomic, copy)HBServiceReceivedBlock receivedBlock;

@end

@implementation HBServiceManager

+ (HBServiceManager *)defaultManager
{
    static HBServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBServiceManager alloc] init];
    });
    return manager;
}

- (void)Post:(NSString *)api dict:(NSMutableDictionary *)dict block:(HBServiceReceivedBlock)receivedBlock
{
    [dict setObject:KAppKeyStudy forKey:KWBAppKey];
    [[HBHTTPBaseRequest requestWithSubUrl:api] startWithMethod:HBHTTPRequestMethodPOST parameters:dict completion:^(id responseObject, NSError *error) {
        if (error) {
            NSDictionary *userDic = error.userInfo;
            NSString *descValue = userDic[@"NSLocalizedDescription"];
            if ([descValue containsString:@"401"]) {
                //token过期，需要重新登录
                [Navigator pushLoginController];
            }
        }
        if (receivedBlock) {
            NSLog(@"responseObject=\r\n%@", responseObject);
            receivedBlock(responseObject,error);
        }
        self.receivedBlock = nil;
    }];
}

- (void)requestRegister:(NSString *)user pwd:(NSString *)pwd type:(NSString *)type smsCode:(NSString *)sms_code codeId:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:pwd      forKey:@"password"];
    [dicInfo setObject:type     forKey:@"type"];
    [dicInfo setObject:sms_code forKey:@"sms_code"];
    [dicInfo setObject:code_id  forKey:@"code_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/auth/register" dict:dicInfo block:receivedBlock];
}

- (void)requestLogin:(NSString *)user pwd:(NSString *)pwd completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:pwd      forKey:@"password"];
    [dicInfo setObject:KAppKeyStudy forKey:KWBAppKey];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;

    [[HBHTTPBaseRequest requestWithSubUrl:@"/api/auth/login"] startWithMethod:HBHTTPRequestMethodPOST parameters:dicInfo completion:^(id responseObject, NSError *error) {
        if (receivedBlock) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [[HBDataSaveManager defaultManager] saveUserByDict:responseObject];
            }
            receivedBlock(responseObject,error);
            self.receivedBlock = nil;
        }
    }];
}

- (void)requestLogout:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/auth/logout" dict:dicInfo block:receivedBlock];
}

- (void)requestSmsCode:(NSString *)user token:(NSString *)token phone:(NSString *)phone service_type:(HBRequestSmsType)service_type completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    if (user) {
        [dicInfo setObject:user     forKey:@"user"];
    }
    if (token) {
        [dicInfo setObject:token    forKey:@"token"];
    }
    [dicInfo setObject:phone        forKey:@"phone"];
    [dicInfo setObject:@(service_type) forKey:@"service_type"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/auth/smscode" dict:dicInfo block:receivedBlock];
}

- (void)requestUserInfo:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdateUser:(NSString *)user token:(NSString *)token display_name:(NSString *)display_name gender:(NSInteger)gender completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:display_name    forKey:@"display_name"];
    [dicInfo setObject:@(gender)    forKey:@"gender"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/update" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdatePhone:(NSString *)user token:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:phone    forKey:@"phone"];
    [dicInfo setObject:sms_code    forKey:@"sms_code"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/phone/update" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdatePwd:(NSString *)user token:(NSString *)token password:(NSString *)password sms_code:(NSString *)sms_code completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:password    forKey:@"password"];
    [dicInfo setObject:sms_code    forKey:@"sms_code"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/password/update" dict:dicInfo block:receivedBlock];
}

- (void)requestVerifyCode:(NSString *)icode completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:icode     forKey:@"icode"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/icode/verify" dict:dicInfo block:receivedBlock];
}

- (void)requestUserBookset:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/bookset/mine" dict:dicInfo block:receivedBlock];
}

- (void)requestAllBookset:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/bookset/all" dict:dicInfo block:receivedBlock];
}

- (void)requestBooksetCreate:(NSString *)user token:(NSString *)token name:(NSString *)name books:(NSString *)bookIds free:(NSString *)freeIds completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:name    forKey:@"name"];
    [dicInfo setObject:bookIds    forKey:@"books"];
    [dicInfo setObject:freeIds    forKey:@"free"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/bookset/create" dict:dicInfo block:receivedBlock];
}

- (void)requestBooksetSub:(NSString *)user token:(NSString *)token bookset_id:(NSString *)bookset_id months:(NSString *)months completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:bookset_id    forKey:@"bookset_id"];
    [dicInfo setObject:months    forKey:@"months"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/bookset/subscribe" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacher:(NSString *)user teacher:(NSString *)teacher completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    if (teacher) {
        [dicInfo setObject:teacher    forKey:@"teacher"];
    }
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherAssign:(NSString *)user teacher:(NSString *)teacher completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:teacher    forKey:@"teacher"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ///api/teacher/associate
    [self Post:@"/api/teacher/assign" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherUnAssign:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/unassociate" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherUnAssignStu:(NSString *)user student_id:(NSString *)student_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:student_id    forKey:@"student_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/s/unassociate" dict:dicInfo block:receivedBlock];
}

- (void)requestDirectorAss:(NSString *)user director:(NSString *)director completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:director    forKey:@"director"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/director/associate" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/list" dict:dicInfo block:receivedBlock];
}

- (void)requestClass:(NSString *)user class_id:(NSString *)class_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:class_id    forKey:@"class_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class" dict:dicInfo block:receivedBlock];
}

- (void)requestClassMember:(NSString *)user class_id:(NSInteger)class_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(class_id)    forKey:@"class_id"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class/member" dict:dicInfo block:receivedBlock];
}

- (void)requestStudentList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/student" dict:dicInfo block:receivedBlock];
}

- (void)requestClassList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/class" dict:dicInfo block:receivedBlock];
}

- (void)requestClassCreate:(NSString *)user name:(NSString *)name bookset_id:(NSString *)bookset_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:name     forKey:@"name"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class/create" dict:dicInfo block:receivedBlock];
}

- (void)requestClassDelete:(NSString *)user class_id:(NSString *)class_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:class_id     forKey:@"class_id"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class/delete" dict:dicInfo block:receivedBlock];
}

- (void)requestClassJoin:(NSString *)user class_id:(NSString *)class_id user_ids:(NSString *)user_ids completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:class_id     forKey:@"class_id"];
    [dicInfo setObject:user_ids     forKey:@"user_ids"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class/join" dict:dicInfo block:receivedBlock];
}

- (void)requestClassQuit:(NSString *)user class_id:(NSString *)class_id user_ids:(NSString *)user_ids completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:class_id     forKey:@"class_id"];
    [dicInfo setObject:user_ids     forKey:@"user_ids"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/class/quit" dict:dicInfo block:receivedBlock];
}

- (void)requestTaskAssign:(NSString *)user book_id:(NSInteger)book_id class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    [dicInfo setObject:@(class_id)     forKey:@"class_id"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/task/assign" dict:dicInfo block:receivedBlock];
}

- (void)requestTaskList:(NSString *)user class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(class_id)     forKey:@"class_id"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/task/list" dict:dicInfo block:receivedBlock];
}

- (void)requestBookInfo:(NSString *)user book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/exam" dict:dicInfo block:receivedBlock];
}

- (void)requestTaskListOfClass:(NSString *)user class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(class_id)     forKey:@"class_id"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ///api/exam/class/list
    [self Post:@"/api/exam/class/list" dict:dicInfo block:receivedBlock];
}

- (void)requestTaskListOfStudent:(NSString *)user from:(NSInteger)from count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(from)     forKey:@"from"];
    [dicInfo setObject:@(count)     forKey:@"count"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/task/student/list" dict:dicInfo block:receivedBlock];
}

- (void)requestSubmitScore:(NSString *)user book_id:(NSInteger)book_id exam_id:(NSInteger)exam_id question_stat:(NSString *)jsonStr completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    [dicInfo setObject:@(exam_id)     forKey:@"exam_id"];
    [dicInfo setObject:jsonStr     forKey:@"question_stat"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/exam/score/submit" dict:dicInfo block:receivedBlock];
}

- (void)requestTaskListOfTeacher:(NSString *)user from:(NSInteger)from count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(from)     forKey:@"from"];
    [dicInfo setObject:@(count)     forKey:@"count"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/exam/teacher/list" dict:dicInfo block:receivedBlock];
}

- (void)requestUserScore:(NSString *)user book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/exam/score/user/list" dict:dicInfo block:receivedBlock];
}

- (void)requestUserScore:(NSString *)user exam_id:(NSInteger)exam_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(exam_id)     forKey:@"exam_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/exam/score/list" dict:dicInfo block:receivedBlock];
}

- (void)requestUserScore:(NSString *)user class_id:(NSInteger)class_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(class_id)     forKey:@"class_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/exam/score/class/list" dict:dicInfo block:receivedBlock];
}

@end
