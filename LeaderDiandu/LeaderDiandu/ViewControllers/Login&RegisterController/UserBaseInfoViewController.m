//
//  UserBaseInfoViewController.m
//  magicEnglish
//
//  Created by libin.tian on 3/6/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import "UserBaseInfoViewController.h"

#import "DJTitledTextField.h"
#import "RadioGroupView.h"
#import "AppUser.h"
#import "UserHeaderButton.h"

#import "ChangePwdViewController.h"
#import "ActionSheetDatePicker.h"

static const CGFloat kImgLength = 800.0f;


@interface UserBaseInfoViewController ()
<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DJTitledTextFieldDelegate>

@property (nonatomic, strong) UserHeaderButton* userButton;

@property (nonatomic, strong) DJTitledTextField* nickField;
@property (nonatomic, strong) DJTitledTextField* genderField;
@property (nonatomic, strong) DJTitledTextField* birthdayField;

@property (nonatomic, strong) UIButton* changePwdButton;
@property (nonatomic, strong) UIButton* saveButton;
@property (nonatomic, strong) RadioGroupView* genderRadio;

@property (nonatomic, strong) UIImage* uploadImage;
@property (nonatomic, copy) NSString* imageUrl;

@property (nonatomic, strong) UIView* pickerView;
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) UIToolbar* toolBar;

@property (nonatomic, assign) long long birthday;

@end

@implementation UserBaseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.whiteSpace = 16.0f;
        self.topSpace = 24.0f;
        if ([DE isPad]) {
            self.topSpace = 180.0f;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navBarTitle = @"修改个人资料";
    
    self.bgImageView.hidden = YES;
    
    NSMutableArray *barItems = [NSMutableArray arrayWithCapacity:4];
    CGRect rc = CGRectMake(0.0f, self.view.hidden, self.view.width, 216 + 44.0f);
    self.pickerView = [[UIView alloc] initWithFrame:rc];
    
    rc.size.height = 44.0f;
    self.toolBar = [[UIToolbar alloc] initWithFrame:rc];
    self.toolBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelTimeSelector:)];
                                
    [barItems addObject:cancelItem];
    
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [barItems addObject:spaceItem];
    
    UIBarButtonItem* confirmItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(confirmTimeSelector:)];
    [barItems addObject:confirmItem];
    [self.toolBar setItems:barItems];
    [self.pickerView addSubview:self.toolBar];
    
    rc.origin.y += rc.size.height;
    rc.size.height = (self.pickerView.height - self.toolBar.height);
    self.datePicker = [[UIDatePicker alloc] initWithFrame:rc];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    // 最小1900
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateMin = [format dateFromString:@"1900-01-01"];
    NSDate* dateMax = [format dateFromString:@"2020-01-01"];
    NSDate* currentDate = nil;
    if ([DE.me.birthday length] > 0) {
        currentDate = [NSDate dateWithTimeIntervalSince1970:DE.me.birthday.longLongValue / 1000];
        if ([currentDate earlierDate:dateMin] || [currentDate laterDate:dateMax]) {
            currentDate = [format dateFromString:@"2000-01-01"];
        }
    }
    else {
        currentDate = [format dateFromString:@"2000-01-01"];
    }
    self.datePicker.maximumDate = dateMax;
    self.datePicker.minimumDate = dateMin;
    self.datePicker.date = currentDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    [self.pickerView addSubview:self.datePicker];
    
    [self.view addSubview:self.pickerView];
    self.pickerView.hidden = YES;
    
    
    [self loadUserBaseInfo];
}

- (void)createLayoutViews
{
    CGRect rc = CGRectMake(self.view.width / 2.0f - 30.0f, 0.0f, 60.0f, 60.0f);
    //中间头像
    self.userButton = [UserHeaderButton createButtonWithTarget:self
                                                        action:@selector(headerButtonPressed:)];
    self.userButton.centerX = self.view.width / 2.0f;
    self.userButton.top = 20.0f;
    [self.userButton setImageWithURL:[NSURL URLWithString:DE.me.userImageUrl] placeholderImage:nil];
    [self addToLayoutView:self.userButton];

    CGFloat height = [DE isPad] ? 50.0f : 30.0f;
    rc = CGRectMake(self.leftSpace, 0.0f, self.view.width - self.leftSpace*2.0f, height);
    self.nickField = [[DJTitledTextField alloc] initWithFrame:rc
                                                        title:@"昵称"
                                               textFieldValue:[DataEngine sharedInstance].me.userNickName
                                                  placeHolder:@"你的昵称"];
    [self addToLayoutView:self.nickField];
    
    self.genderRadio = [[RadioGroupView alloc] initWithFrame:CGRectZero];
    [self.genderRadio resetButtonTitles:@[@"男", @"女"] defaultIndex:0];
    self.genderField = [[DJTitledTextField alloc] initWithFrame:rc
                                                          title:@"性别"
                                                      thirdView:self.genderRadio];
    [self addToLayoutView:self.genderField];
    
    self.birthdayField = [[DJTitledTextField alloc] initWithFrame:rc
                                                            title:@"生日"
                                                      buttonTitle:@""
                                                     defaultValue:@"请选择出生日期"];
    self.birthdayField.valueButton.backgroundColor = [UIColor whiteColor];
    self.birthdayField.valueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.birthdayField.valueButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    self.birthdayField.delegate = self;
    [self.birthdayField.valueButton setBackgroundImage:[UIImage resizebleImageNamed:@"in_put.png"]
                                              forState:UIControlStateNormal];
    
//    [self addToLayoutView:self.birthdayField];
    
    rc.size.height = [DE isPad] ? 60.0f : 40.0f;
    self.changePwdButton = [ViewCreatorHelper createBlueButtonWithTitle:@"修改密码"
                                                                  frame:rc
                                                                 target:self
                                                                 action:@selector(changePwdButtonPressed:)];
    [self addToLayoutView:self.changePwdButton];
    
    self.saveButton = [ViewCreatorHelper createYellow2ButtonWithTitle:@"保存"
                                                                frame:rc
                                                               target:self
                                                               action:@selector(saveButtonPressed:)];
    [self addToLayoutView:self.saveButton];
    
    if ([DE isPad]) {
        UIFont* font = [UIFont systemFontOfSize:20.0f];
        self.nickField.titleLabel.font = font;
        self.nickField.textField.font = font;
        self.genderField.titleLabel.font = font;
        self.birthdayField.titleLabel.font = font;
        self.birthdayField.valueButton.titleLabel.font = font;
        
        self.saveButton.titleLabel.font = font;
        self.changePwdButton.titleLabel.font = font;
    }
}

- (void)loadUserBaseInfo
{
    [MBHudUtil showActivityView:@"加载中" inView:self.view];
    [DE getUserBaseInfo:DE.me.userID.stringValue
             onComplete:
     ^(NSDictionary *sourceDic, NSInteger errorCode, NSString *errorMsg, BOOL hasMore, id otherData) {
         if (errorCode == RequestErrorCodeSuccess) {
             //
             [MBHudUtil hideActivityView:self.view];
             [self resetData];
         }
         else {
             [MBHudUtil showFailedActivityView:errorMsg inView:self.view];
         }
     }];
}

- (void)resetData
{
    self.nickField.value = DE.me.userNickName;
    if (DE.me.userGender.integerValue == userGenderMale) {
        self.genderRadio.currentIndex = 0;
    }
    else {
        self.genderRadio.currentIndex = 1;
    }
    self.birthday = DE.me.birthday.longLongValue;
    if (self.birthday > 0) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:self.birthday/1000];
        NSDateFormatter* format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString* birthday = [format stringFromDate:date];
        self.birthdayField.value = birthday;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - targets

- (void)hideTimeSelector
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.pickerView.top = self.view.height;
                     }
                     completion:^(BOOL finished) {
                         self.pickerView.hidden = YES;
                     }];
}

- (void)cancelTimeSelector:(id)sender
{
    [self hideTimeSelector];
}

- (void)confirmTimeSelector:(id)sender
{
    NSDate* date = self.datePicker.date;
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* birthday = [format stringFromDate:date];
    
    self.birthdayField.value = birthday;
    
    NSTimeInterval time = [date timeIntervalSince1970];
    self.birthday = (long long)time * 1000;
    
    [self hideTimeSelector];
}

- (void)showTimeSelector:(DJTitledTextField*)titleField
{
    [self.view endEditing:YES];
    
    self.pickerView.hidden = NO;
    [self.view bringSubviewToFront:self.pickerView];
    self.pickerView.top = self.view.height;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.pickerView.bottom = self.view.height;
                     }];
}


- (void)headerButtonPressed:(id)sender
{
    // 选择图片
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册选择", nil];
    [sheet showInView:self.view];
}

- (void)changePwdButtonPressed:(id)sender
{
    ChangePwdViewController* vc = [[ChangePwdViewController alloc] init];
    [Navigator pushController:vc];
}

- (void)saveButtonPressed:(id)sender
{
    NSString* nickName = [self.nickField.textField.text trimText];
    if (nickName.length == 0) {
        [MBHudUtil showFailedActivityView:@"请设置您的昵称" inView:self.view];
        return;
    }
    userGender gender = userGenderFemale;
    if (self.genderRadio.currentIndex == 0) {
        gender = userGenderMale;
    }
    [MBHudUtil showActivityView:@"正在保存" inView:self.view];

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long birth = (long long)time * 1000;

    [DE updateUserBaseInfo:nickName
                    gender:gender
                  birthday:[NSString stringWithFormat:@"%lld", birth]//[NSString stringWithFormat:@"%lld", self.birthday]
                onComplete:
     ^(NSDictionary *sourceDic, NSInteger errorCode, NSString *errorMsg, BOOL hasMore, id otherData) {
         if (errorCode == RequestErrorCodeSuccess) {
             [MBHudUtil showFinishActivityView:@"保存成功" inView:self.view];
         }
         else {
             [MBHudUtil showFailedActivityView:@"保存失败" inView:self.view];
         }
     }];
}

#pragma mark - DJTitledTextFieldDelegate
- (void)titleFieldPressed:(DJTitledTextField*)titleField
{
    if (titleField == self.birthdayField) {
        [self showTimeSelector:titleField];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* cameraPicker=[[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    if (buttonIndex == 0) {
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            return;
        }
    }
    else if (buttonIndex == 1) {
        // 相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else {
            return;
        }
    }
    else {
        return;
    }

    [self presentViewController:cameraPicker animated:YES completion:^{
        ;
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
    NSString *mediaType =[NSString stringWithFormat:[info objectForKey:UIImagePickerControllerMediaType] ,nil];
    if ([mediaType isEqualToString:@"public.image"]) {
        //添加图片处理view
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [self uploadImage:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


#pragma mark - network request
- (void)uploadImage:(UIImage*)image
{
    if (image == nil) {
        return;
    }
    if (image.size.width > kImgLength || image.size.height > kImgLength) {
        self.uploadImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(kImgLength, kImgLength)];
    }
    else {
        self.uploadImage = image;
    }
    
    [MBHudUtil showActivityView:@"正在上传" inView:self.view];
    [DE updateImage:self.uploadImage
         onComplete:
     ^(NSDictionary *sourceDic, NSInteger errorCode, NSString *errorMsg, BOOL hasMore, id otherData) {
         if (errorCode == RequestErrorCodeSuccess) {
             [MBHudUtil hideActivityView:self.view];
             // 更新头像
             [self.userButton setImageWithURL:[NSURL URLWithString:DE.me.userImageUrl] placeholderImage:nil];
         }
         else {
             [MBHudUtil showFailedActivityView:@"头像更新失败" inView:self.view];
         }
     }];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
