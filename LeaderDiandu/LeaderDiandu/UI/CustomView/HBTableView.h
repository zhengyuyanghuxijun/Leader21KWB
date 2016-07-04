//
//  HBTableView.h
//  LeaderDiandu
//
//  Created by xijun on 15/11/13.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBTableView : UITableView

- (void)showEmptyView:(NSString *)icon tips:(NSString *)tips;
- (void)hideEmptyView;

@end
