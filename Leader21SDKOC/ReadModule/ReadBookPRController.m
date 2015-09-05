//
//  ReadBookPRAnimationController.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookPRController.h"

@implementation ReadBookPRController

- (void)setPRObj:(PRXMLObject *)prXMLObj indexName:(NSString *)indexName contentViewVC:(ReadBookContentViewController *)contentViewVC
{
    [super setModelBaseObj:prXMLObj indexName:indexName contentViewVC:contentViewVC];
}

- (NSData *)prepareVoiceData:(NSString *)xmlObjName indexName:(NSString *)indexName
{
    return [ReadBookResourceFactory screenReaderPRVoiceData:indexName resourceName:xmlObjName];
}

- (void)readModelChange
{
    [super readModelChange];
    self.animationView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    [self.animationView addGestureRecognizer:tapGesture];
}

- (void)tapGestureHandle:(id)sender
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         if (self.readBookViewController.readBookToolBar.alpha == 1) {
                             self.readBookViewController.readBookToolBar.alpha = 0;
                         }
                         else
                         {
                             self.readBookViewController.readBookToolBar.alpha = 1;
                         }
                     }];
    
}
@end
