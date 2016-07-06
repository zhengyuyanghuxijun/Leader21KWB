//
//  UITextField+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "UITextField+HBExt.h"
#import <objc/runtime.h>

static char *targetKey;
static char *actionKey;
static char *limitKey;

@implementation UITextField (LengthLimit)

- (void)addLengthLimit:(int)limitMax target:(id)target action:(SEL)action
{
    NSString *limitStr = [NSString stringWithFormat:@"%d",limitMax];
    objc_setAssociatedObject(self, &limitKey, limitStr, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &actionKey, NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(UITextFieldTextDidChangeByLimit) forControlEvents:UIControlEventEditingChanged];
}


- (void)UITextFieldTextDidChangeByLimit
{
    NSString *limitStr = objc_getAssociatedObject(self, &limitKey);
    NSInteger maxLength = [limitStr integerValue];
    
    id target = objc_getAssociatedObject(self, &targetKey);
    NSString *actionStr = objc_getAssociatedObject(self, &actionKey);
    SEL runAction  = NSSelectorFromString(actionStr);
    
    NSString *toBeString = self.text;
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"] ||    //简体中文输入法，包括拼音，五笔，手写
        [lang isEqualToString:@"zh-Hant"])      //繁体中文输入法
    {
        //获取高亮部分
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        if (!position)  //没有高亮选择的文本，则对已输入的文本进行字数统计和限制
        {
            if (toBeString.length > maxLength)
            {
                //找到当前输入光标位置, 删除超出内容
                UITextPosition *beginning = self.beginningOfDocument;
                UITextRange *selectedRange = self.selectedTextRange;
                UITextPosition *selectionStart = selectedRange.start;
                
                NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
                self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(location-(toBeString.length-maxLength), toBeString.length-maxLength) withString:@""];
                
                if (target && [target respondsToSelector:runAction])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:runAction ];
#pragma clang diagnostic pop
                }
            }
        }
        else    //有高亮选择的文本，则暂不对文本进行统计和限制
        {
            
        }
    }
    else    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    {
        if (toBeString.length > maxLength)
        {
            //找到当前输入光标位置, 删除超出内容
            UITextPosition *beginning = self.beginningOfDocument;
            UITextRange *selectedRange = self.selectedTextRange;
            UITextPosition *selectionStart = selectedRange.start;
            
            NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(location-(toBeString.length-maxLength), toBeString.length-maxLength) withString:@""];
            
            if (target && [target respondsToSelector:runAction])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:runAction ];
#pragma clang diagnostic pop
            }
        }
    }
}

@end
