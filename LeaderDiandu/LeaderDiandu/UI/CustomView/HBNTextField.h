//
//  HBNTextField.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import <UIKit/UIKit.h>


typedef enum {
    HBNTextFieldTypeDefault,
    HBNTextFieldTypeRound,
    HBNTextFieldTypePassword,
    HBNTextFieldTypeVerifyCode,
    HBNTextFieldTypeWithTitle
}HBNTextFieldType;

typedef enum{
    HBNTextFieldErrorMessageTypeDefault,
    HBNTextFieldErrorMessageTypeYellow
}HBNTextFieldErrorMessageType;


@interface HBNTextField : UITextField

@property (nonatomic, assign) CGSize imgSize;
@property (nonatomic, readonly, getter=isShowingMessage) BOOL showingMessage;

@end

@interface UITextField ()
- (void)setupTextFieldWithIconName:(NSString *)name;
- (void)setupTextFieldWithType:(HBNTextFieldType)type withIconName:(NSString *)name;
- (void)showErrorMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message withType:(HBNTextFieldErrorMessageType)type;
- (void)setTitleLabelText:(NSString *)title;
- (void)hideErrorMessage;

@end