//
//  HBRankingListCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/21.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBRankingListCell.h"
#import "HBRankBookEntity.h"
#import "UIImageView+AFNetworking.h"

#define LABELFONTSIZE 22.0f

@implementation HBRankingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //奖杯
    self.cupImgView  = [[UIImageView alloc] init];
    self.cupImgView.image = [UIImage imageNamed:@"board-icn-champion"];
    self.cupImgView.frame = CGRectMake(10, 40, 25, 30);
    [self addSubview:self.cupImgView];
    
    //排名
    self.rankingLabel = [[UILabel alloc] init];
    self.rankingLabel.frame = CGRectMake(10, 0, 25, 100);
    self.rankingLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.rankingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rankingLabel];
    
    //书籍封皮
    self.bookCoverImage = [[UIImageView alloc] init];
//    self.bookCoverImage.image = [UIImage imageNamed:@"icn-group"];
    self.bookCoverImage.frame = CGRectMake(35 + 10, 20, 50, 60);
    [self addSubview:self.bookCoverImage];
    
    //书籍名称
    self.bookNameLabel = [[UILabel alloc] init];
    self.bookNameLabel.frame = CGRectMake(self.bookCoverImage.frame.origin.x + self.bookCoverImage.frame.size.width + 10, 10, 250, 100/2);
    [self addSubview:self.bookNameLabel];
    
    //阅读频度
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.frame = CGRectMake(self.bookNameLabel.frame.origin.x, 100/2, 200, 100/2 - 10);
    self.countLabel.textColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:self.countLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 100 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBRankBookEntity *rankBookEntity = (HBRankBookEntity *)sender;
    
    if (rankBookEntity) {
        
        if ([rankBookEntity.rank isEqualToString:@"1"]) {
            self.cupImgView.hidden = NO;
            self.rankingLabel.hidden = YES;
        }
        else if ([rankBookEntity.rank isEqualToString:@"2"] || [rankBookEntity.rank isEqualToString:@"3"]) {
            self.cupImgView.hidden = YES;
            self.rankingLabel.hidden = NO;
            self.rankingLabel.textColor = [UIColor colorWithHex:0xff8903];
            self.rankingLabel.text = rankBookEntity.rank;
        }else{
            self.cupImgView.hidden = YES;
            self.rankingLabel.hidden = NO;
            self.rankingLabel.textColor = [UIColor blackColor];
            self.rankingLabel.text = rankBookEntity.rank;
        }
        
        self.bookNameLabel.text = rankBookEntity.book_title_cn;
        self.countLabel.text = [NSString stringWithFormat:@"%@%@", @"频度指数 ", rankBookEntity.count];
        
        NSString *fileIdStr = rankBookEntity.file_id;
        fileIdStr = [fileIdStr lowercaseString];
        NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
        [self.bookCoverImage setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
    }
}

@end
