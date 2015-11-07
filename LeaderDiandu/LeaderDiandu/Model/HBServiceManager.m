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

#import "AFHTTPRequestOperation.h"

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
    [dict setObject:KAppKeyKWB forKey:KWBAppKey];
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
    [dicInfo setObject:KAppKeyKWB forKey:KWBAppKey];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;

    [[HBHTTPBaseRequest requestWithSubUrl:@"/api/auth/login"] startWithMethod:HBHTTPRequestMethodPOST parameters:dicInfo completion:^(id responseObject, NSError *error) {
        if (receivedBlock) {
            if (error.code == 0) {
                NSString *pwdMd5 = [pwd md5];
                [[HBDataSaveManager defaultManager] saveUserByDict:responseObject pwd:pwdMd5];
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
    [self Post:@"/api/auth/smscodev2/v2" dict:dicInfo block:receivedBlock];
}

- (void)requestUserInfo:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdateUser:(NSString *)user token:(NSString *)token display_name:(NSString *)display_name gender:(NSInteger)gender age:(NSInteger)age completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    if (display_name) {
        [dicInfo setObject:display_name    forKey:@"display_name"];
    }
    [dicInfo setObject:@(gender)    forKey:@"gender"];
    [dicInfo setObject:@(age)    forKey:@"age"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/update" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdatePhone:(NSString *)user token:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code code_id:(NSString *)code_id  completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:phone    forKey:@"phone"];
    [dicInfo setObject:sms_code    forKey:@"sms_code"];
    [dicInfo setObject:code_id    forKey:@"code_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/phone/update" dict:dicInfo block:receivedBlock];
}

- (void)requestUpdatePwd:(NSString *)phone token:(NSString *)token password:(NSString *)password sms_code:(NSString *)sms_code code_id:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:phone     forKey:@"phone"];
    if (token) {
        [dicInfo setObject:token    forKey:@"token"];
    }
    [dicInfo setObject:password    forKey:@"password"];
    [dicInfo setObject:sms_code    forKey:@"sms_code"];
    [dicInfo setObject:code_id     forKey:@"code_id"];
    
    if (_receivedBlock) {
        return;
    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/user/password/forget" dict:dicInfo block:receivedBlock];
}

- (void)requestModifyPwd:(NSString *)user token:(NSString *)token old_password:(NSString *)old_password new_password:(NSString *)new_password completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    if (token) {
        [dicInfo setObject:token    forKey:@"token"];
    }
    [dicInfo setObject:old_password    forKey:@"old_password"];
    [dicInfo setObject:new_password    forKey:@"new_password"];
    
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

- (void)requestDirectorList:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/director/list" dict:dicInfo block:receivedBlock];
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

- (void)requestDirectorUnAss:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/director/unassociate" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/teacher/list" dict:dicInfo block:receivedBlock];
}

- (void)requestUnBindingTeacher:(NSString *)user teacher:(NSString *)teacher token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:teacher     forKey:@"teacher"];
    [dicInfo setObject:token forKey:@"token"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/director/s/unassociate" dict:dicInfo block:receivedBlock];
}

- (void)requestTeacherTaskList:(NSString *)user fromTime:(NSInteger)fromTime toTime:(NSInteger)toTime completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:@(fromTime)      forKey:@"from_time"];
    [dicInfo setObject:@(toTime)        forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/exam/director/list" dict:dicInfo block:receivedBlock];
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
    
//    if (_receivedBlock) {
//        return;
//    }
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
    
//    if (_receivedBlock) {
//        return;
//    }
    self.receivedBlock = receivedBlock;
    ////api/exam/student/list
    [self Post:@"/api/task/student/list" dict:dicInfo block:receivedBlock];
}

- (void)requestSubmitScore:(NSString *)user book_id:(NSInteger)book_id exam_id:(NSInteger)exam_id score:(NSInteger)score fromTime:(NSInteger)fromTime toTime:(NSInteger)toTime question_stat:(NSString *)jsonStr completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user             forKey:@"user"];
    [dicInfo setObject:@(book_id)       forKey:@"book_id"];
//    [dicInfo setObject:@(bookset_id)  forKey:@"bookset_id"];
    [dicInfo setObject:@(exam_id)       forKey:@"exam_id"];
    [dicInfo setObject:@(score)         forKey:@"score"];
    [dicInfo setObject:@(fromTime)      forKey:@"from_time"];
    [dicInfo setObject:@(toTime)        forKey:@"to_time"];
    [dicInfo setObject:jsonStr          forKey:@"question_stat"];
    
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

- (void)requestUpdateBookProgress:(NSString *)user token:(NSString *)token book_id:(NSInteger)book_id progress:(NSInteger)progress completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    [dicInfo setObject:@(progress)     forKey:@"progress"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/book/progress/update" dict:dicInfo block:receivedBlock];
}

- (void)requestBookProgress:(NSString *)user token:(NSString *)token book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/book/progress" dict:dicInfo block:receivedBlock];
}

- (void)requestBookProgress:(NSString *)user token:(NSString *)token bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/bookset/progress" dict:dicInfo block:receivedBlock];
}

- (void)requestReportBookProgress:(NSString *)user
                            token:(NSString *)token
                          book_id:(NSInteger)book_id
                       bookset_id:(NSInteger)bookset_id
                        from_time:(NSString *)from_time
                          to_time:(NSString *)to_time
                        from_page:(NSString *)from_page
                          to_page:(NSString *)to_page
                       total_page:(NSString *)total_page
                       completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:@(book_id)     forKey:@"book_id"];
    [dicInfo setObject:@(bookset_id)     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    [dicInfo setObject:from_page     forKey:@"from_page"];
    [dicInfo setObject:to_page     forKey:@"to_page"];
    [dicInfo setObject:total_page     forKey:@"total_page"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/book/reading/report" dict:dicInfo block:receivedBlock];
}

/**
 *  获取系统消息
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param from_time        为起始时间，单位为秒。
 *  @param receivedBlock    回调Block
 */
- (void)requestSystemMsg:(NSString *)user token:(NSString *)token from_time:(NSString *)from_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/msg/list" dict:dicInfo block:receivedBlock];
}

/**
 *  用户获取订单记录
 *
 *  @param user             用户名
 *  @param from_time        为起始时间，单位为秒。
 *  @param count            每次列表数目
 *  @param receivedBlock    回调Block
 */
- (void)requestBillList:(NSString *)user from_time:(NSString *)from_time count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:@(count)     forKey:@"count"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/order/list" dict:dicInfo block:receivedBlock];
}

/**
 *  用户通过VIP码付费
 *
 *  @param user             用户名
 *  @param vip_code         VIP码
 *  @param product          一个固定值
 *  @param receivedBlock    回调Block
 */
- (void)requestVipOrder:(NSString *)user vip_code:(NSString *)vip_code product:(NSString *)product completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:vip_code     forKey:@"vip_code"];
    [dicInfo setObject:product     forKey:@"product"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/order/vip/create" dict:dicInfo block:receivedBlock];
}

- (void)requestChannelOrder:(NSString *)user token:(NSString *)token channel:(NSString *)channel quantity:(NSInteger)quantity product:(NSString *)product completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:user     forKey:@"user"];
    [dicInfo setObject:token forKey:@"token"];
    [dicInfo setObject:channel     forKey:@"channel"];
    [dicInfo setObject:@(quantity)     forKey:@"quantity"];
    [dicInfo setObject:product     forKey:@"product"];
    
    if (_receivedBlock) {
        return;
    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/order/create" dict:dicInfo block:receivedBlock];
}

/**
 *  阅读人数统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingStudent:(NSString *)teacher_id bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/reading/student" dict:dicInfo block:receivedBlock];
}

/**
 *  阅读次数统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingTimes:(NSString *)teacher_id bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/reading" dict:dicInfo block:receivedBlock];
}

/**
 *  阅读时长统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingTime:(NSString *)teacher_id bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/reading/time" dict:dicInfo block:receivedBlock];
}

/**
 *  阅读排行统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingRank:(NSString *)teacher_id token:(NSString *)token bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    
    if (teacher_id) {
        [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    }
    [dicInfo setObject:token    forKey:@"token"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/reading/rank" dict:dicInfo block:receivedBlock];
}

/**
 *  作业知识点统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestExamKnowledge:(NSString *)teacher_id bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    
    [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/exam/knowledge" dict:dicInfo block:receivedBlock];
}

/**
 *  作业题目认知能力统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestExamAbility:(NSString *)teacher_id bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    
    [dicInfo setObject:teacher_id     forKey:@"teacher_id"];
    [dicInfo setObject:bookset_id     forKey:@"bookset_id"];
    [dicInfo setObject:from_time     forKey:@"from_time"];
    [dicInfo setObject:to_time     forKey:@"to_time"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/stat/exam/ability" dict:dicInfo block:receivedBlock];
}

/**
 *  查询系统最新版本
 *
 *  @param client               android 或者 ios
 *  @param current_version      版本
 *  @param branch               stable 表示发布版本，dev 表示开发版本
 */
- (void)requestCheckUpdate:(NSString *)client current_version:(NSInteger)current_version branch:(NSString *)branch completion:(HBServiceReceivedBlock)receivedBlock
{
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    
    [dicInfo setObject:client     forKey:@"client"];
    [dicInfo setObject:@(current_version)     forKey:@"current_version"];
    [dicInfo setObject:branch     forKey:@"branch"];
    
    //    if (_receivedBlock) {
    //        return;
    //    }
    
    self.receivedBlock = receivedBlock;
    [self Post:@"/api/config/check/update" dict:dicInfo block:receivedBlock];
}

@end
