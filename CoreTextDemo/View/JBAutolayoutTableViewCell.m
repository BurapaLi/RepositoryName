//
//  JBAutolayoutTableViewCell.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/29.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "JBAutolayoutTableViewCell.h"
#import "Masonry.h"
#import "JBNews.h"
#import "UIImageView+WebCache.h"

#define KMargin 5

@interface JBAutolayoutTableViewCell ()
@property (nonatomic,weak) UIImageView *headerImageView;
@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *descrLable;
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,assign) CGFloat descrLableHeight;
@end

@implementation JBAutolayoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    //imageView.backgroundColor = [UIColor redColor];
    self.headerImageView = imageView;
    [self addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc] init];
    //titleLable.backgroundColor = [UIColor yellowColor];
    self.titleLable = titleLable;
    titleLable.numberOfLines = 0;
    titleLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLable];
    
    UILabel *descrLable = [[UILabel alloc] init];
    //descrLable.backgroundColor = [UIColor purpleColor];
    self.descrLable = descrLable;
    descrLable.numberOfLines = 0;
    descrLable.font = [UIFont systemFontOfSize:13];
    [self addSubview:descrLable];
    
    UIView *bottomView = [[UIView alloc] init];
    //bottomView.backgroundColor = [UIColor redColor];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    __weak JBAutolayoutTableViewCell *weakSelf = self;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(KMargin);
        make.left.equalTo(weakSelf.mas_left).offset(KMargin);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(KMargin);
        make.left.equalTo(weakSelf.headerImageView.mas_right).offset(KMargin);
        make.right.equalTo(weakSelf.mas_right).offset(-5);
        make.height.mas_equalTo (25);
    }];
    
    [descrLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_bottom).offset (KMargin);
        make.left.equalTo(weakSelf.headerImageView.mas_right).offset(KMargin);
        make.right.equalTo(weakSelf.mas_right).offset(-KMargin);
        
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(weakSelf.descrLable.mas_bottom).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.mas_left).offset(0);
        make.right.mas_equalTo(weakSelf.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setNewsModel:(JBNews *)newsModel {
    _newsModel = newsModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.imgurl]];
    
    self.titleLable.text = newsModel.title;
    self.descrLable.text = newsModel.descr;
    //CGFloat cellHeight = self.descrLable.frame.size.height;
    
   }



- (CGFloat)cellHeightWithNews:(JBNews *)news {
    _newsModel = news;
    __weak JBAutolayoutTableViewCell *weakSelf = self;
    
    //CGFloat height = [news.descr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40-2*KMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;

    [self.descrLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.descrLableHeight);
    }];
    [self layoutIfNeeded];

    CGFloat cellHeight = CGRectGetMaxY(self.descrLable.frame) + 5;
   
    return cellHeight<self.headerImageView.frame.size.height+10?self.headerImageView.frame.size.height+10:cellHeight;
}

- (CGFloat)descrLableHeight {
    if (!_descrLableHeight) {
        
        _descrLableHeight = [self.newsModel.descr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40-2*KMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    return _descrLableHeight;
}

@end
