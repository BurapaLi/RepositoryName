//
//  JBNewsViewModel.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/3.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "ViewModel.h"
@class JBNews;
@interface JBNewsViewModel : ViewModel
//请求数据
- (void)requestNewsData;
//跳转的新闻详情页面
- (void)pushToNewsDetailViewControllerWithNews:(JBNews *)jbNews
                        WithRootViewController:(UIViewController *)superViewController;
@end
