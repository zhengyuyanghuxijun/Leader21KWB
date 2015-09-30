//
//  MJProgressHUD.h
//
//

#import <UIKit/UIKit.h>

@interface MJProgressHUD : UIView

@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) NSString *detailsLabelText;
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIFont *detailsLabelFont;

- (id)initWithView:(UIView *)view;
- (id)initWithWindow:(UIWindow *)window;
- (void)hide;

@end
