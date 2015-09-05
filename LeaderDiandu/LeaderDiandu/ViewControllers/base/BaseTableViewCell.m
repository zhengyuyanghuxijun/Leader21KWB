//
//  BaseTableViewCell.m
//  magicEnglish
//
//  Created by libin.tian on 9/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "ViewCreatorHelper.h"


@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _lineView = [ViewCreatorHelper lineWithWidth:10.0f];
        [self.contentView addSubview:_lineView];
        _lineViewColor = _lineView.backgroundColor;
        _showUnderLine = YES;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
//        UIImage* arrow = [UIImage imageNamed:@"list_arrow.png"];
//        _customAccessoryView = [[UIImageView alloc] initWithImage:arrow];
    }
    return self;
}

- (void)configCellWithData:(id)data atIndex:(NSIndexPath*)indexPath positionType:(tableViewCellPosition)pos
{
    self.itemData = data;
    
    if (self.showUnderLine) {
        self.lineView.hidden = NO;
        if ([DE isPad]) {
            self.width = 768.0f;
        }
        if (pos == tableViewCellPositionBottom) {
            self.lineView.width = self.width;
        }
        else {
            self.lineView.width = self.width - 13.0f;
        }
    }
    else {
        self.lineView.hidden = YES;
    }
}

+ (CGFloat)cellHeightForObject:(id)obj
{
    return 60.0f;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showUnderLine) {
        self.lineView.right = self.width;
        self.lineView.bottom = self.height;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.showUnderLine) {
        self.lineView.backgroundColor = self.lineViewColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.showUnderLine) {
        self.lineView.backgroundColor = self.lineViewColor;
    }
}

@end
