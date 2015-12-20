//
//  HBServiceManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/28.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBModelConst.h"
#import "HBDataSaveManager.h"
#import "HBUserEntity.h"

typedef void(^HBServiceReceivedBlock) (id responseObject, NSError *error);

@interface HBServiceManager : NSObject

+ (HBServiceManager *)defaultManager;

/**
 *  注册
 *
 *  @param user             用户名
 *  @param pwd              密码
 *  @param type             1-学生；10-老师（目前暂时可忽略）
 *  @param sms_code/code_id 分别为请求短信验证码时服务器返回的值
 *  @param receivedBlock 回调Block
 */
- (void)requestRegister:(NSString *)user pwd:(NSString *)pwd type:(NSString *)type smsCode:(NSString *)sms_code codeId:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  通过用户昵称注册
 *
 *  @param display_name     用户名
 *  @param pwd              密码
 *  @param receivedBlock 回调Block
 */
- (void)requestRegistByName:(NSString *)display_name pwd:(NSString *)pwd smsCode:(NSString *)sms_code codeId:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取验证码图片
 *
 *  @param receivedBlock 回调Block
 */
- (void)requestGetVerifyImg:(HBServiceReceivedBlock)receivedBlock;

/**
 *  登录
 *
 *  @param user             用户名
 *  @param pwd              密码
 *  @param receivedBlock 回调Block
 */
- (void)requestLogin:(NSString *)user pwd:(NSString *)pwd completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  退出登录
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestLogout:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取短信验证码
 *  注册时无需提供 user 和 token 参数，其它已确定用户名的情况则需要提供该参数
 *  客户端应提供保护机制，避免用户短时间内重复获取短信验证码
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param phone            手机号
 *  @param service_type 表示验证码用途。 1-注册；2-修改密码；3-忘记密码；4-绑定手机
 *  @param receivedBlock 回调Block
 */
- (void)requestSmsCode:(NSString *)user token:(NSString *)token phone:(NSString *)phone service_type:(HBRequestSmsType)service_type completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取用户信息
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestUserInfo:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  更新用户信息
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @gender 性别， 1-男，2-女
 *  @display_name gender age 等参数至少有一个即可，多值可选
 *  @param receivedBlock 回调Block
 */
- (void)requestUpdateUser:(NSString *)user token:(NSString *)token display_name:(NSString *)display_name gender:(NSInteger)gender age:(NSInteger)age  completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  绑定手机
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param phone            电话号码
 *  @param sms_code         短信验证码
 *  @param receivedBlock 回调Block
 */
- (void)requestUpdatePhone:(NSString *)user token:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code code_id:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  忘记密码
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param password         新密码
 *  @param sms_code         短信验证码
 *  @param receivedBlock 回调Block
 */
- (void)requestUpdatePwd:(NSString *)phone token:(NSString *)token password:(NSString *)password sms_code:(NSString *)sms_code code_id:(NSString *)code_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  修改密码
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param old_password     旧密码
 *  @param new_password     新密码
 *  @param receivedBlock 回调Block
 */
- (void)requestModifyPwd:(NSString *)user token:(NSString *)token old_password:(NSString *)old_password new_password:(NSString *)new_password completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  验证邀请码
 *
 *  @param icode         验证码
 *  @param receivedBlock 回调Block
 */
- (void)requestVerifyCode:(NSString *)icode completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取用户当前订阅的套餐
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestUserBookset:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取所有可选套餐
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestAllBookset:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  创建套餐
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param name             套餐名
 *  @param bookIds          "book_id_1,book_id_2,book_id_3"
 *  @param free 是免费书本列表，不论它是否列在 books 中，缺省都会将其记做 books 的一部分
 *  @param receivedBlock 回调Block
 */
- (void)requestBooksetCreate:(NSString *)user token:(NSString *)token name:(NSString *)name books:(NSString *)bookIds free:(NSString *)freeIds completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  订阅套餐
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param bookset_id       套餐id
 *  @param months           订阅时间（可能改为 weeks 更便于计算）
 *  @param receivedBlock 回调Block
 */
- (void)requestBooksetSub:(NSString *)user token:(NSString *)token bookset_id:(NSString *)bookset_id months:(NSString *)months completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取老师信息
 *
 *  @param user             用户名
 *  @param teacher          老师注册ID，非后台数据库ID
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacher:(NSString *)user teacher:(NSString *)teacher completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  绑定一位老师,可以作为学生查找老师、绑定老师用（两个接口功能相同）
 *
 *  @param user             用户名
 *  @param teacher          老师注册ID，非后台数据库ID
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacherAssign:(NSString *)user teacher:(NSString *)teacher completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  学生解除绑定老师
 *
 *  @param user             用户名
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacherUnAssign:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  老师解除绑定一位学生
 *  注意不要和学生解除绑定的接口混淆
 *  学生会同时退出相关班级/群组
 *
 *  @param user             用户名
 *  @param student_id       老师注册ID，非后台数据库ID
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacherUnAssignStu:(NSString *)user student_id:(NSString *)student_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  老师获取教研员列表
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestDirectorList:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  绑定一位教导员
 *
 *  @param user             用户名
 *  @param director         教导员注册ID，非后台数据库ID
 *  @param receivedBlock 回调Block
 */
- (void)requestDirectorAss:(NSString *)user director:(NSString *)director completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  老师解除绑定教研员
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestDirectorUnAss:(NSString *)user token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取与一位教研员相关联的老师列表，只有教研员有权限调用该接口
 *
 *  @param user             用户名
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacherList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  教研员解除一位老师的绑定
 *
 *  @param user             用户名
 *  @param teacher_id       老师ID
 *  @param receivedBlock 回调Block
 */
- (void)requestUnBindingTeacher:(NSString *)user teacher:(NSString *)teacher token:(NSString *)token completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  教研员获取相关老师的作业统计信息
 *
 *  @param user             用户名
 *  @param receivedBlock 回调Block
 */
- (void)requestTeacherTaskList:(NSString *)user fromTime:(NSInteger)fromTime toTime:(NSInteger)toTime completion:(HBServiceReceivedBlock)receivedBlock;

#pragma mark --- teacher API
/**
 *  获取班级信息,只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param receivedBlock 回调Block
 */
- (void)requestClass:(NSString *)user class_id:(NSString *)class_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取班级学生列表，只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param receivedBlock 回调Block
 */
- (void)requestClassMember:(NSString *)user class_id:(NSInteger)class_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取绑定老师的学生信息，只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param receivedBlock 回调Block
 */
- (void)requestStudentList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取班级列表，只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param receivedBlock 回调Block
 */
- (void)requestClassList:(NSString *)user completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  创建班级，只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param name             班级名称
 *  @param bookset_id       对应年级（即业务逻辑中得套餐ID）
 *  @param receivedBlock 回调Block
 */
- (void)requestClassCreate:(NSString *)user name:(NSString *)name bookset_id:(NSString *)bookset_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  注销或删除班级，只有老师有权限调用该接口
 *  班级中的所有学生将会自动退出
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param receivedBlock 回调Block
 */
- (void)requestClassDelete:(NSString *)user class_id:(NSString *)class_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  将一个或多个 user（即学生）加入一个班级,只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param user_ids         要加入班级的学生
 *  @param receivedBlock 回调Block
 */
- (void)requestClassJoin:(NSString *)user class_id:(NSString *)class_id user_ids:(NSString *)user_ids completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  将一个或多个 user （即学生）退出一个班级,只有老师有权限调用该接口
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param user_ids         要加入班级的学生
 *  @param receivedBlock 回调Block
 */
- (void)requestClassQuit:(NSString *)user class_id:(NSString *)class_id user_ids:(NSString *)user_ids completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  老师布置作业
 *
 *  @param user             用户名
 *  @param book_id          书本ID
 *  @param class_id         班级ID
 *  @param bookset_id       套餐ID
 *  @param receivedBlock 回调Block
 */
- (void)requestTaskAssign:(NSString *)user book_id:(NSInteger)book_id class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  根据班级获取作业列表
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param bookset_id       套餐ID
 *  @param receivedBlock 回调Block
 */
- (void)requestTaskList:(NSString *)user class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取一个测试或作业的信息
 *
 *  @param user             用户名
 *  @param book_id          作业ID
 *  @param receivedBlock 回调Block
 */
- (void)requestBookInfo:(NSString *)user book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取一个班的作业列表
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param bookset_id 为班级对应的套餐ID，冗余参数，仅作为参数校验用
 *  @param receivedBlock 回调Block
 */
- (void)requestTaskListOfClass:(NSString *)user class_id:(NSInteger)class_id bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  学生获取作业列表
 *
 *  @param user             用户名
 *  @param from             列表记录开始的时间
 *  @param count            每次列表数目
 *  @param receivedBlock 回调Block
 */
- (void)requestTaskListOfStudent:(NSString *)user from:(NSInteger)from count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  学生用户提交测试/作业的成绩
 *
 *  @param user             用户名
 *  @param book_id          书ID
 *  @param exam_id          测验ID
 *  @param question_stat 为一个JSON数组格式的题目统计信息，包括每道题的知识点、难度、能力点、结果...等原始数据： [{knowledge:2, ability: 1, difficulty: 3, score: 0/1}]， 其中 score 表示该题是否得分
 *  @param receivedBlock 回调Block
 */
- (void)requestSubmitScore:(NSString *)user book_id:(NSInteger)book_id exam_id:(NSInteger)exam_id score:(NSInteger)score fromTime:(NSInteger)fromTime toTime:(NSInteger)toTime question_stat:(NSString *)jsonStr completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  老师获取自己布置的作业列表
 *
 *  @param user             用户名
 *  @param from             列表记录开始的时间
 *  @param count            每次列表数目
 *  @param receivedBlock 回调Block
 */
- (void)requestTaskListOfTeacher:(NSString *)user from:(NSInteger)from count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  根据一本书，获取一个学生的测试/作业分数
 *
 *  @param user             用户名
 *  @param book_id          一本书的ID
 *  @param receivedBlock 回调Block
 */
- (void)requestUserScore:(NSString *)user book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  根据某个测试获取学生成绩列表
 *
 *  @param user             用户名
 *  @param exam_id          测试的ID
 *  @param receivedBlock 回调Block
 */
- (void)requestUserScore:(NSString *)user exam_id:(NSInteger)exam_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  根据班级获取成绩列表
 *  注意一本书对应的既可以是测试，也可以是作业成绩，以 type 标识为准， 1-测试，2-作业。其中测试成绩一般不带有班级和作业ID等信息
 *
 *  @param user             用户名
 *  @param class_id         班级ID
 *  @param receivedBlock 回调Block
 */
- (void)requestUserScore:(NSString *)user class_id:(NSInteger)class_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  学生上报一本书的阅读进度
 *  当进度为100时，并且该学生没有绑定老师，系统会自动为其布置作业（参考返回应答中的 exam_assigned 参数）
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param book_id          书本ID
 *  @param progress为0-100 之间的数字。如果上报的进度小于当前服务器端进度，则保持后者
 *  @param receivedBlock 回调Block
 */
- (void)requestUpdateBookProgress:(NSString *)user token:(NSString *)token book_id:(NSInteger)book_id progress:(NSInteger)progress completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取用户书本阅读进度
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param book_id          书本ID
 *  @param receivedBlock 回调Block
 */
- (void)requestBookProgress:(NSString *)user token:(NSString *)token book_id:(NSInteger)book_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取用户某个套餐的书本阅读进度
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param bookset_id       套餐ID
 *  @param receivedBlock 回调Block
 */
- (void)requestBookProgress:(NSString *)user token:(NSString *)token bookset_id:(NSInteger)bookset_id completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  上报用户读书行为
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param book_id          书本ID
 *  @param bookset_id       套餐ID
 *  @param from_time        阅读开始时间
 *  @param to_time          阅读结束时间
 *  @param from_page        阅读开始页码
 *  @param to_page          阅读结束页码
 *  @param total_page       书籍共多少页
 *  @param receivedBlock    回调Block
 */
- (void)requestReportBookProgress:(NSString *)user
                            token:(NSString *)token
                          book_id:(NSInteger)book_id
                       bookset_id:(NSInteger)bookset_id
                        from_time:(NSString *)from_time
                          to_time:(NSString *)to_time
                        from_page:(NSString *)from_page
                          to_page:(NSString *)to_page
                       total_page:(NSString *)total_page
                       completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  获取系统消息
 *
 *  @param user             用户名
 *  @param token            登录返回的凭证
 *  @param from_time        为起始时间，单位为秒。
 *  @param receivedBlock    回调Block
 */
- (void)requestSystemMsg:(NSString *)user token:(NSString *)token from_time:(NSString *)from_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  用户获取订单记录
 *
 *  @param user             用户名
 *  @param from_time        为起始时间，单位为秒。
 *  @param count            每次列表数目
 *  @param receivedBlock    回调Block
 */
- (void)requestBillList:(NSString *)user from_time:(NSString *)from_time count:(NSInteger)count completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  用户通过VIP码付费
 *
 *  @param user             用户名
 *  @param vip_code         VIP码
 *  @param product          一个固定值
 *  @param receivedBlock    回调Block
 */
- (void)requestVipOrder:(NSString *)user vip_code:(NSString *)vip_code product:(NSString *)product completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  用户通过支付宝或微信付费
 *
 *  @param user             用户名
 *  @param channel          支付渠道,支付宝@"zfb"
 *  @param quantity         几个月
 *  @param product          一个固定值
 *  @param receivedBlock    回调Block
 */
- (void)requestChannelOrder:(NSString *)user token:(NSString *)token channel:(NSString *)channel quantity:(NSInteger)quantity product:(NSString *)product completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  用户通过支付宝或微信付费
 *
 *  @param user             用户名
 *  @param total_fee        支付金额
 *  @param quantity         几个月
 *  @param payReceipt       苹果支付凭证
 *  @param receivedBlock    回调Block
 */
- (void)requestIAPNotify:(NSString *)user token:(NSString *)token total_fee:(NSString *)total_fee quantity:(NSInteger)quantity payReceipt:(NSString *)payReceipt transactionID:(NSString *)transactionID completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  阅读人数统计
 *
 *  @param teacher_id         老师ID，teacher_id 可换为 director_id
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingStudent:(HBUserEntity *)entity bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  阅读次数统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingTimes:(HBUserEntity *)entity bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  阅读时长统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingTime:(HBUserEntity *)entity bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  阅读排行统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestReadingRank:(HBUserEntity *)entity token:(NSString *)token bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  作业知识点统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestExamKnowledge:(HBUserEntity *)entity bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  作业题目认知能力统计
 *
 *  @param teacher_id         老师ID
 *  @param bookset_id         套餐id
 *  @param from_time          为起始时间，单位为秒。
 *  @param to_time            为结束时间，单位为秒。
 */
- (void)requestExamAbility:(HBUserEntity *)entity bookset_id:(NSString *)bookset_id from_time:(NSString *)from_time to_time:(NSString *)to_time completion:(HBServiceReceivedBlock)receivedBlock;

/**
 *  查询系统最新版本
 *
 *  @param client               android 或者 ios
 *  @param current_version      版本
 *  @param branch               stable 表示发布版本，dev 表示开发版本
 */
- (void)requestCheckUpdate:(NSString *)client current_version:(NSInteger)current_version branch:(NSString *)branch completion:(HBServiceReceivedBlock)receivedBlock;

@end
