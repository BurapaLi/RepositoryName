//
//  JBTableViewCell.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/29.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBNews;
@interface JBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImgaeView;
@property (weak, nonatomic) IBOutlet UILabel *topLable;
@property (weak, nonatomic) IBOutlet UILabel *bottomLable;

- (CGFloat)cellHeightWithModel:(JBNews *)news;
@end
