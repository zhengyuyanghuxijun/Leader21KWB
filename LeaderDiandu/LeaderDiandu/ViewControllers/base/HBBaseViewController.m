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
    
//    UIImageView *backgroundImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    backgroundImg.image = [UIImage imageNamed:@"star_bg"];
//    [self.view addSubview:backgroundImg];
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    
    CGRect rect = self.view.frame;
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), KHBNaviBarHeight)];
//    navView.image = [UIImage imageNamed:@"resource_title_bg"];
    navView.backgroundColor = RGBCOLOR(249, 154, 11);
    [self.view addSubview:navView];
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
