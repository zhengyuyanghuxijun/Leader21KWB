//
//  KxMenu.h
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by wangpo
//

#import <Foundation/Foundation.h>

#pragma mark - 下拉列表条目类
@interface KxMenuItem : NSObject

@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic, assign) BOOL isShowRedPoint;//是否展示红点

/**
 *  @brief 下拉列表item初始化方法
 *
 *  @param title   显示的title
 *  @param image   图标
 *  @param image   目标
 *  @param image   动作
 *
 *  @return	单个item
 */
+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

@end

#pragma mark - 下拉列表管理类
@interface FTMenu : NSObject

/**
 *	@brief	下拉列表显示
 *
 *	@param 	frame 	显示frame
 *	@param 	view 	父视图
 *	@param 	menuItems 	item集合
 *
 *	@return	nil
 */
+ (void) showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems;

/**
 *	@brief	下拉列表删除
 *
 *	@return	nil
 */
+ (void) dismissMenu;

@end
