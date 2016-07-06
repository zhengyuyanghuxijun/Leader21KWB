//
//  UITextView+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "UITextView+HBExt.h"
#import <objc/runtime.h>

static char *targetKey;
static char *actionKey;
static char *limitKey;

@implementation UITextView (LengthLimit)

- (void)addLengthLimit:(int)limitMax target:(id)target action:(SEL)action
{
    NSString *limitStr = [NSString stringWithFormat:@"%d",limitMax];
    objc_setAssociatedObject(self, &limitKey, limitStr, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &actionKey, NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextViewTextDidChangeByLimit) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)UITextViewTextDidChangeByLimit
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


//不使用重写这种方法，而是用下面的实现方式
//- (void)removeFromSuperview
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


+ (void)load
{
    Class class = [self class];
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(removeFromSuperview);
    SEL swizzledSelector = @selector(removeFromSuperviewExt);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO
    //originalSelector -> swizzledMethod
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)   //removeFromSuperview没有被重写
    {
        //class_replaceMethod函数，该函数的行为可以分为两种：如果类中不存在name指定的方法，则类似于class_addMethod函数一样会添加方法；如果类中已存在name指定的方法，则类似于method_setImplementation一样替代原方法的实现
        //swizzledSelector -> originalMethod
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else                //removeFromSuperview在其他地方被重写
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//调用removeFromSuperview时，其实调用的是removeFromSuperviewExt
- (void)removeFromSuperviewExt
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperviewExt];  //其实调用的是removeFromSuperview（注意此处不是死循环哦）
}


@end
