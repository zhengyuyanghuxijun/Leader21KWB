//
//  DHSlideMenuViewController.m
//  ByqIOSApps
//
//  Created by DumbbellYang on 14/11/28.
//  Copyright (c) 2014年 DumbbellYang. All rights reserved.
//

#import "DHSlideMenuViewController.h"
#import "DHSlideMenuController.h"

static NSString * const kSlideMenuViewControllerCellReuseId = @"kSlideMenuViewControllerCellReuseId";

@interface DHSlideMenuViewController ()

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) NSArray *controllers;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) UIColor *selectedColor;

@end

@implementation DHSlideMenuViewController

- (id)initWithMenus:(NSArray *)titles MenuImages:(NSArray *)images TabBarControllers:(NSArray*)controllers;{
    NSParameterAssert(titles);
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _titles = titles;
        _images = images;
        _controllers = controllers;
    }
    return self;
}

#pragma mark - Managing the view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = nil;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSlideMenuViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    self.tableView.frame = CGRectMake(0, 100, 200, screenSize.height-100);
}

#pragma mark - Configuring the view’s layout behavior
- (UIStatusBarStyle)preferredStatusBarStyle{
    // Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headButtonAction:(id)sender
{
    DHSlideMenuController *svc = [DHSlideMenuController sharedInstance];
    [svc hideSlideMenuViewController:YES];
    
    Class viewCtlClass = NSClassFromString(_headerClassName);
    if (viewCtlClass && [viewCtlClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *viewController = [[viewCtlClass alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:viewController animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSParameterAssert(self.titles);
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    float controlX = 20;
    float controlY = 80;
    float controlH = 50;
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlH, controlH)];
    headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    [view addSubview:headView];
    
    controlX += controlH;
    float controlW = 120;
    UIButton *buttonInfo = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    buttonInfo.backgroundColor = [UIColor clearColor];
    [buttonInfo addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonInfo];
    
    controlX = 0;
    controlY = 0;
    controlW = 100;
    controlH = 20;
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor lightGrayColor];
    nameLbl.font = [UIFont systemFontOfSize:14];
    nameLbl.text = _headerName;
    [buttonInfo addSubview:nameLbl];
    
    controlY += controlH;
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    phoneLbl.backgroundColor = [UIColor clearColor];
    phoneLbl.textColor = [UIColor lightGrayColor];
    phoneLbl.font = [UIFont systemFontOfSize:14];
    phoneLbl.text = _headerPhone;
    [buttonInfo addSubview:phoneLbl];
    
    controlX += controlW;
    controlY = 15;
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlH, controlH)];
    arrowImg.image = [UIImage imageNamed:@"menu_icon_user_open"];
    [buttonInfo addSubview:arrowImg];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.titles);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSlideMenuViewControllerCellReuseId forIndexPath:indexPath];
    if ((self.images != nil) && (self.images.count > indexPath.row)){
        cell.imageView.image = [UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
    }
    cell.backgroundColor = self.backgroundColor;
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(170, 20, 20, 20)];
    arrowImg.image = [UIImage imageNamed:@"menu_icon_user_open"];
    [cell addSubview:arrowImg];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DHSlideMenuController *svc = [DHSlideMenuController sharedInstance];
    NSInteger index = indexPath.row;
    NSLog(@"select row:%ld", (long)index);
    if (index < [self.controllers count]){
        [svc resetCurrentViewToMainViewController];
        
        NSString *viewCtlName = self.controllers[index];
        
        if ([viewCtlName isEqualToString:@""]) { //联系客服
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打客服电话？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0;
            
            [alertView show];
        }
        
        Class viewCtlClass = NSClassFromString(viewCtlName);
        if (viewCtlClass && [viewCtlClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *viewController = [[viewCtlClass alloc] init];
            [[AppDelegate delegate].globalNavi pushViewController:viewController animated:YES];
        }
    }
    
    [svc hideSlideMenuViewController:YES];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
    }else{
        NSString *allString = [NSString stringWithFormat:@"tel:4008126161"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }
}

#if 0
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
#endif

@end
