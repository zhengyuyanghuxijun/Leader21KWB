//
//  HBBaseViewController.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/26.
//
//

#import "HBBaseViewController.h"

@interface HBBaseViewController ()
{
    
}

@end

@implementation HBBaseViewController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    //设置navigationBar背景颜色
    [naviBar setBarTintColor:KLeaderRGB];
    //设置navigationBar Title颜色和字体
    [naviBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    //设置返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
//    UIImageView *backgroundImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    backgroundImg.image = [UIImage imageNamed:@"star_bg"];
//    [self.view addSubview:backgroundImg];
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self willPop];
    [super dismissViewControllerAnimated:flag completion:completion];
}

-(void)willPop{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
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

@implementation HBBaseViewController(CallBack)

@end
