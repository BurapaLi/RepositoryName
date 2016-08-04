//
//  JBNewsViewModel.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/3.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "JBNewsViewModel.h"
#import "JBNews.h"
#import "JBNewsDetailViewController.h"

@implementation JBNewsViewModel
//请求数据
- (void)requestNewsData {
    //这里网络请求数据 用本地数据代替
    
    //对于请求成功 或失败 应该单独处理 这里只处理请求成功的回调
    NSMutableArray *jbNewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"News.txt" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *dicArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (dicArray && dicArray.count !=0) {
        for (NSDictionary *dict in dicArray) {
            JBNews *jbNews = [JBNews objectWithKeyValues:dict];
            [jbNewsArray addObject:jbNews];
        }
    }
    
    //触发回调
    self.returnValueCallback(jbNewsArray);
}



//跳转的新闻详情页面
- (void)pushToNewsDetailViewControllerWithNews:(JBNews *)jbNews
                 WithRootViewController:(UIViewController *)superViewController  {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    JBNewsDetailViewController *jbNewsDetailVc = [sb instantiateViewControllerWithIdentifier:@"jbNewsDetailVc"];
    jbNewsDetailVc.news = jbNews;
    [superViewController.navigationController pushViewController:jbNewsDetailVc animated:YES];
}

@end
