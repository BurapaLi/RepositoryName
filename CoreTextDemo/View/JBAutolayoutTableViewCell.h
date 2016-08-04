//
//  JBAutolayoutTableViewCell.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/29.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBNews;

@interface JBAutolayoutTableViewCell : UITableViewCell
@property (nonatomic,strong) JBNews *newsModel;

- (CGFloat)cellHeightWithNews:(JBNews *)news;
@end
