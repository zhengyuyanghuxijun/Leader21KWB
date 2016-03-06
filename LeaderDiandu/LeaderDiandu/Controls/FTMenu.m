//
//  KxMenu.m
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by wangpo
//
#import "FTMenu.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIImage+Extend.h"

@interface KxMenuView : UIImageView
- (void)dismissMenu:(BOOL) animated;
- (void)showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems;
@end


#pragma mark - KxMenuOverlay 遮罩层
@interface KxMenuOverlay : UIView
@end

@implementation KxMenuOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {
        
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[KxMenuView class]]
                && [v respondsToSelector:@selector(dismissMenu:)]) {
                
                [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
            }
        }
    }
}

@end

#pragma mark - KxMenuItem 菜单条目

@implementation KxMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[KxMenuItem alloc] init:title
                              image:image
                             target:target
                             action:action];
}

- (id)init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    if (self = [super init]) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (BOOL)enabled
{
    return _target != nil && _action != NULL;
}

- (void)performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

@end



#pragma mark - KxMenuView 下拉列表视图

@implementation KxMenuView{
    UIView                      *_contentView;
    NSArray                     *_menuItems;//下拉列表条目
    CGRect                      _originalMenuViewFrame;//原始frame
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];    
    if(self) {
        self.userInteractionEnabled = YES;
        self.image = [[UIImage imageNamed:@"ystv.png"] stretchableImageWithLeftCapWidth:75 topCapHeight:100];
    }
    
    return self;
}



- (void)showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems
{
    self.frame = frame;
    _originalMenuViewFrame = frame;
    _menuItems = menuItems;
    
    //下拉菜单内容
    _contentView = [self mkContentViewWithFrame:frame];
    [self addSubview:_contentView];
    
    //根视图view <-- KxMenuOverlay <-- KxMenuView <-- _contentView <--KxMenuItem
    //遮罩层
    KxMenuOverlay *overlay = [[KxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = _originalMenuViewFrame;
    self.frame = (CGRect){_originalMenuViewFrame.origin.x, _originalMenuViewFrame.origin.y, _originalMenuViewFrame.size.width, 1};
    
    //展示
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
   
}

- (void)showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems currentID:(NSInteger)currentID
{
    self.frame = frame;
    _originalMenuViewFrame = frame;
    _menuItems = menuItems;
    
    //下拉菜单内容
    _contentView = [self mkContentViewWithFrame:frame currentID:currentID];
    [self addSubview:_contentView];
    
    //根视图view <-- KxMenuOverlay <-- KxMenuView <-- _contentView <--KxMenuItem
    //遮罩层
    KxMenuOverlay *overlay = [[KxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = _originalMenuViewFrame;
    self.frame = (CGRect){_originalMenuViewFrame.origin.x, _originalMenuViewFrame.origin.y, _originalMenuViewFrame.size.width, 1};
    
    //展示
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
}

- (void)dismissMenu:(BOOL) animated
{
    if (self.superview) {
     
        if (animated) {
            
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect)(CGRect){_originalMenuViewFrame.origin.x, _originalMenuViewFrame.origin.y, _originalMenuViewFrame.size.width, 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[KxMenuOverlay class]]){
                                     [self.superview removeFromSuperview];
                                 }
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[KxMenuOverlay class]]){
                 [self.superview removeFromSuperview];
            }
           [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
    
    UIButton *button = (UIButton *)sender;
    KxMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
}

//下拉列表视图内容布局
- (UIView *) mkContentViewWithFrame:(CGRect)contentFrame
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    CGFloat kLeftMarginX =18.0f;
//    CGFloat kMidMarginX = 16.0f;
    CGFloat kRightMarginX = 18.0f;
    CGFloat kMarginY = 8.0f;
    
    CGFloat maxImageWidth = 33;
    CGFloat maxItemHeight = 47;
    if (iPhone5) {
        maxItemHeight = 35;
    }
    CGFloat maxItemWidth = contentFrame.size.width;
    

//    const CGFloat titleX = kLeftMarginX  + maxImageWidth + kMidMarginX;
//    const CGFloat titleWidth = maxItemWidth - titleX - kRightMarginX;
    
    const CGFloat titleX = 0.0f;
    const CGFloat titleWidth = maxItemWidth;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.opaque = NO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, -10, 60, maxItemHeight*[_menuItems count]+10)];
    imgView.image = [UIImage imageNamed:@"bookshelf-bg-class"];
    [contentView addSubview:imgView];
    
    CGFloat itemY = 10;
    NSUInteger itemNum = 0;
    for (KxMenuItem *menuItem in _menuItems) {
        
        //itemView
        const CGRect itemFrame = (CGRect){-3, itemY-10, maxItemWidth, maxItemHeight};
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
//        itemView.backgroundColor = [UIColor yellowColor];
        itemView.opaque = NO;
        [contentView addSubview:itemView];
        
        //button
        if (menuItem.enabled) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            CGRect pFrame = itemView.bounds;
            pFrame.origin.x = 5;
            pFrame.origin.y = 5;
            pFrame.size.width -= 10;
            pFrame.size.height -= 10;
            button.frame = pFrame;
            button.enabled = menuItem.enabled;
            button.backgroundColor = [UIColor clearColor];
            button.opaque = NO;
//            [button setBackgroundImage:[UIImage imageWithColor:RGB(242, 242, 242)] forState: UIControlStateHighlighted];
            button.autoresizingMask = UIViewAutoresizingNone;
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:button];
            
            CGRect bgImgFrame = itemView.bounds;
            bgImgFrame.origin.x = 15;
            bgImgFrame.origin.y = 10;
            bgImgFrame.size.width -= 30;
            bgImgFrame.size.height = bgImgFrame.size.width;
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:bgImgFrame];
            bgImgView.image = [UIImage imageNamed:@"bookshelf-icn-class-slected"];
            [itemView addSubview:bgImgView];
        }
        
        //icon
        if (menuItem.image) {
            const CGRect imageFrame = (CGRect){kLeftMarginX, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }

        //titleLabel
        if (menuItem.title.length > 0) {
            
         const CGRect titleFrame = (CGRect){
                titleX,
                kMarginY,
                titleWidth,
                maxItemHeight - kMarginY * 2
            };
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [itemView addSubview:titleLabel];            
        }
        
        //添加红点
        if(menuItem.isShowRedPoint){
            const CGRect imageFrame = {kLeftMarginX, kMarginY, 10, 10};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.backgroundColor = [UIColor redColor];
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (itemNum < _menuItems.count - 1) {
            CGRect lineFrame = (CGRect){10, itemY + maxItemHeight -0.5 - 10, maxItemWidth - 26, 0.5};
            UIView *gradientView = [[UIView alloc] init];
            gradientView.backgroundColor = RGB(198, 198, 198);
            gradientView.frame = lineFrame;
            [contentView addSubview:gradientView];
        }
        
        itemY += maxItemHeight;
        ++itemNum;
    }    
    
    contentView.frame = (CGRect){0, 1, maxItemWidth, itemY};
    
    return contentView;
}

//下拉列表视图内容布局
- (UIView *) mkContentViewWithFrame:(CGRect)contentFrame currentID:(NSInteger)currentID
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    NSUInteger itemCount = [_menuItems count];
    if (itemCount == 0)
        return nil;
    
    CGFloat kLeftMarginX =18.0f;
    CGFloat kMarginY = 8.0f;
    
    CGFloat maxImageWidth = 33;
    CGFloat maxItemHeight = 47;
    if (iPhone5 || iPhone4) {
        maxItemHeight = 30;
    } else if (myAppDelegate.isPad) {
        maxItemHeight = 80;
    }
    CGFloat maxItemWidth = contentFrame.size.width;
    
    const CGFloat titleX = 0.0f;
    const CGFloat titleWidth = maxItemWidth;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.opaque = NO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, -10, 60, maxItemHeight*[_menuItems count]+10)];
    imgView.image = [UIImage imageNamed:@"bookshelf-bg-class"];
    [contentView addSubview:imgView];
    
    CGFloat itemY = 10;
    NSUInteger itemNum = 0;
    for (NSInteger index = 0; index < _menuItems.count; index++) {
        
        KxMenuItem *menuItem = [_menuItems objectAtIndex:index];
        
        //itemView
        const CGRect itemFrame = (CGRect){-3, itemY-10, maxItemWidth, maxItemHeight};
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        //        itemView.backgroundColor = [UIColor yellowColor];
        itemView.opaque = NO;
        [contentView addSubview:itemView];
        
        //button
        if (menuItem.enabled) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            CGRect pFrame = itemView.bounds;
            pFrame.origin.x = 5;
            pFrame.origin.y = 5;
            pFrame.size.width -= 10;
            pFrame.size.height -= 10;
            button.frame = pFrame;
            button.enabled = menuItem.enabled;
            button.backgroundColor = [UIColor clearColor];
            button.opaque = NO;
            //            [button setBackgroundImage:[UIImage imageWithColor:RGB(242, 242, 242)] forState: UIControlStateHighlighted];
            button.autoresizingMask = UIViewAutoresizingNone;
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:button];
            
            CGRect bgImgFrame = itemView.bounds;
            bgImgFrame.origin.x = 15;
            bgImgFrame.size.width -= 30;
            bgImgFrame.size.height = bgImgFrame.size.width;
            bgImgFrame.origin.y = (maxItemHeight-bgImgFrame.size.width) / 2;
            
            if (index == (currentID - 1)) {
                UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:bgImgFrame];
                bgImgView.image = [UIImage imageNamed:@"bookshelf-icn-class-slected"];
                [itemView addSubview:bgImgView];
            }
        }
        
        //icon
        if (menuItem.image) {
            const CGRect imageFrame = (CGRect){kLeftMarginX, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        //titleLabel
        if (menuItem.title.length > 0) {
            
            const CGRect titleFrame = (CGRect){
                titleX,
                kMarginY,
                titleWidth,
                maxItemHeight - kMarginY * 2
            };
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            
            if (index == (currentID - 1)) {
                titleLabel.textColor = [UIColor whiteColor];
            }else{
                titleLabel.textColor = [UIColor grayColor];
            }
            
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [itemView addSubview:titleLabel];
        }
        
        //添加红点
        if(menuItem.isShowRedPoint){
            const CGRect imageFrame = {kLeftMarginX, kMarginY, 10, 10};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.backgroundColor = [UIColor redColor];
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (itemNum < _menuItems.count - 1) {
            CGRect lineFrame = (CGRect){10, itemY + maxItemHeight -0.5 - 10, maxItemWidth - 26, 0.5};
            UIView *gradientView = [[UIView alloc] init];
            gradientView.backgroundColor = RGB(198, 198, 198);
            gradientView.frame = lineFrame;
            [contentView addSubview:gradientView];
        }
        
        itemY += maxItemHeight;
        ++itemNum;
    }
    
    contentView.frame = (CGRect){0, 1, maxItemWidth, itemY};
    
    return contentView;
}

@end


#pragma mark - FTMenu下拉列表管理类

static FTMenu *gMenu;

@implementation FTMenu {
    
    KxMenuView *_menuView;
}

+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gMenu = [[FTMenu alloc] init];
    });
    return gMenu;
}

- (void)showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    _menuView = [[KxMenuView alloc] init];
    [_menuView showMenuWithFrame:frame inView:view  menuItems:menuItems];
}

- (void)showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems currentID:(NSInteger)currentID
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    _menuView = [[KxMenuView alloc] init];
    [_menuView showMenuWithFrame:frame inView:view menuItems:menuItems currentID:currentID];
}

- (void) dismissMenu
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
}

//接口方法
+ (void) showMenuWithFrame:(CGRect)frame inView:(UIView *)view menuItems:(NSArray *)menuItems currentID:(NSInteger)currentID
{
    [[self sharedMenu] showMenuWithFrame:frame inView:view menuItems:menuItems currentID:currentID];
}

+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}





@end
