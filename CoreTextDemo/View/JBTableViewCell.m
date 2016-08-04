//
//  JBTableViewCell.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/29.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "JBTableViewCell.h"
#import "JBNews.h"
@implementation JBTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)cellHeightWithModel:(JBNews *)news {
    CGFloat height = [news.descr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 33.5-2*5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
    return height;
}

@end
