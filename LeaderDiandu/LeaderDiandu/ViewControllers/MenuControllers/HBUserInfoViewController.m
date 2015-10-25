//
//  HBUserInfoViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBUserInfoViewController.h"
#import "HBServiceManager.h"
#import "HBEditNameViewController.h"
#import "HBBindPhoneViewController.h"
#import "HBModifyPwdViewController.h"
#import "HBDataSaveManager.h"
#import "HBHeaderManager.h"
#import "TimeIntervalUtils.h"
#import "FileUtil.h"

#define KTableViewHeaderHeight  120
static NSString * const KUserInfoViewControllerCellReuseId = @"KUserInfoViewControllerCellReuseId";

@interface HBUserInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray     *_titleArr;
    UITableView *_tableView;
}

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSString *headFile;
@property (nonatomic, strong)NSString *filePath;

@end

@implementation HBUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"账号", @"姓名", @"手机", @"修改密码"];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"个人中心";
    
    CGRect rect = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self getUserInfo];
    [self getHeaderAvatar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)getHeaderAvatar
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    self.headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:userEntity.name];
    if (self.headFile == nil) {
        [[HBHeaderManager defaultManager] requestGetAvatar:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
            if (error.code == 0) {
                self.headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:userEntity.name];
                [_tableView reloadData];
            }
        }];
    }
}

- (void)getUserInfo
{
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (responseObject) {
            [[HBDataSaveManager defaultManager] setUserEntityByDict:responseObject];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSParameterAssert(_titleArr);
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KTableViewHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_headerView) {
        self.headerView = nil;
    }
    NSInteger imgWidth = 50;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    _headerView = [[UIView alloc] init];
    float controlW = 70;
    float controlH = 25;
    float controlX = (screenWidth-imgWidth-controlW)/2;
    float controlY = (KTableViewHeaderHeight-imgWidth)/2;
    UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, imgWidth, imgWidth)];
    if (self.headFile) {
        //设置显示圆形头像
        headButton.layer.cornerRadius = imgWidth/2;
        headButton.clipsToBounds = YES;
        UIImage *headImg = [UIImage imageWithContentsOfFile:self.headFile];
        if (headImg == nil) {
            headImg = [UIImage imageNamed:@"menu_user_pohoto"];
        }
        [headButton setImage:headImg forState:UIControlStateNormal];
    } else {
        [headButton setImage:[UIImage imageNamed:@"menu_user_pohoto"] forState:UIControlStateNormal];
    }
    [headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:headButton];
    
    controlX += imgWidth+10;
    controlY += (imgWidth-controlH) / 2;
    UIView *typeView = [self createTypeView:CGRectMake(controlX, controlY, controlW, controlH)];
    [_headerView addSubview:typeView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KTableViewHeaderHeight-1, screenWidth, 1)];
    lineLabel.backgroundColor = RGBEQ(239);
    [_headerView addSubview:lineLabel];
    
    return _headerView;
}

- (UIView *)createTypeView:(CGRect)frame
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:frame];
    UILabel *typeLbl = [[UILabel alloc] initWithFrame:bgView.bounds];
    typeLbl.textAlignment = NSTextAlignmentCenter;
    typeLbl.textColor = [UIColor whiteColor];
    typeLbl.font = [UIFont systemFontOfSize:16];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity.type == 1) {
        if (userEntity.account_status == 1) {
            typeLbl.text = @"普通用户";
            bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
        } else if (userEntity.account_status == 3) {
            //vip过期
            typeLbl.text = @"VIP过期";
            bgView.image = [UIImage imageNamed:@"studentmanage-bg-vipover-user"];
        } else if (userEntity.account_status == 2) {
            typeLbl.text = @"VIP会员";
            bgView.image = [UIImage imageNamed:@"studentmanage-bg-vip-user"];
            CGRect typeFrame = bgView.frame;
            float controlX = CGRectGetMinX(typeFrame);
            float controlW = _tableView.frame.size.width-controlX-10;
            UILabel *validDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, CGRectGetMaxY(typeFrame), controlW, 40)];
            validDateLbl.font = [UIFont systemFontOfSize:14];
            validDateLbl.numberOfLines = 0;
            NSString *dateStr = [TimeIntervalUtils getCNStringYearMonthDayFromTimeinterval:userEntity.vip_time];
            validDateLbl.text = [NSString stringWithFormat:@"有效期:\r\n%@", dateStr];
            [_headerView addSubview:validDateLbl];
        }
    } else if (userEntity.type == 10) {
        typeLbl.text = @"教师";
        bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
    } else {
        typeLbl.text = @"教研员";
        bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
    }
    [bgView addSubview:typeLbl];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_titleArr);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KUserInfoViewControllerCellReuseId];
    NSInteger index = indexPath.row;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KUserInfoViewControllerCellReuseId];
        float viewWidth = self.view.frame.size.width;
        float width = 200;
        UILabel *valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-width-40, 15, width, 20)];
        valueLbl.tag = 1001;
        valueLbl.backgroundColor = [UIColor clearColor];
        valueLbl.textColor = [UIColor lightGrayColor];
        valueLbl.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:valueLbl];
        
        if (index == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (index > 0) {
            UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 15, 20, 20)];
            arrowImg.image = [UIImage imageNamed:@"menu_icon_user_open"];
            [cell.contentView addSubview:arrowImg];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_titleArr objectAtIndex:index];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UILabel *valueLbl = (UILabel *)[cell.contentView viewWithTag:1001];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (index == 0) {
        valueLbl.text = userEntity.name;
    } else if (index == 1) {
        valueLbl.text = userEntity.display_name;
    } else if (index == 2) {
        valueLbl.text = userEntity.phone;
    } else if (index == 3) {
        valueLbl.text = @"******";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (index == 1) {
        HBEditNameViewController *controller = [[HBEditNameViewController alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:controller animated:YES];
    } else if (index == 2) {
        HBBindPhoneViewController *controller = [[HBBindPhoneViewController alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:controller animated:YES];
    } else if (index == 3) {
        HBModifyPwdViewController *controller = [[HBModifyPwdViewController alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)headButtonAction:(id)sender
{
    //在这里呼出下方菜单按钮项
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]                     initWithTitle:@"头像设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"拍照", @"选择本地图片",nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        self.filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //开始上传
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            [[HBHeaderManager defaultManager] requestUpdateAvatar:userEntity.name token:userEntity.token file:_filePath data:data completion:^(id responseObject, NSError *error) {
                
            }];
        }];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
//        UIImageView *smallimage = [[UIImageView alloc] initWithFrame: CGRectMake(50, 120, 40, 40)];
//        smallimage.image = image;
//        [self.view addSubview:smallimage];
    } else {
        [MBHudUtil showTextViewAfter:@"请选择图片"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
