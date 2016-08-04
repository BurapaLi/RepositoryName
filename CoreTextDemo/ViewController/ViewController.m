//
//  ViewController.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/27.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "ViewController.h"
#import "JBNews.h"
#import "News.h"
#import "JBTableViewCell.h"
#import "JBAutolayoutTableViewCell.h"
#import "JBBuyViewController.h"
#import "JBNewsViewModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *myTableView;
@end

@implementation ViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *myTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    self.myTableView = myTableView;
    //xib单元格自适应
    [myTableView registerNib:[UINib nibWithNibName:@"JBTableViewCell" bundle:nil] forCellReuseIdentifier:@"jbcell"];
    //Masonry全代码单元格自适应
    //[myTableView registerClass:[JBAutolayoutTableViewCell class] forCellReuseIdentifier:@"cell"];
    myTableView.estimatedRowHeight = 200;
    //myTableView.rowHeight =  200;
    [self.view addSubview:myTableView];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _context = app.managedObjectContext;
    NSString *oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateData"];
    NSTimeInterval nowTime = [NSDate timeIntervalSinceReferenceDate];
    
    __weak ViewController *weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!oldTime) {//第一次进入程序 去网络请求数据 保存到本地
            
            [self writeData];
        }else {
            if (nowTime - [oldTime doubleValue] > 10) {
                //时间大于10秒，下次再进入页面，刷新数据了  删除本地数据，去请求新数据 刷新表 存储到磁盘
                [weakSelf deleteData];
                [weakSelf writeData];
            } else {
                //从本地读取数据
                [weakSelf getDataInDisk];
            }
        }

       [weakSelf.myTableView.mj_header endRefreshing];
    }];
    [self.myTableView.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    NSMutableArray *gifImages = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i < 61; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"dropdown_anim__000%d@2x.png",i];
        [gifImages addObject:[UIImage imageNamed:imageName]];
    }
    //[footer setImages:gifImages forState:MJRefreshStateRefreshing];
    [footer setImages:gifImages duration:10 forState:MJRefreshStateRefreshing];
    self.myTableView.mj_footer = footer;
    [footer beginRefreshing];
}

- (void)loadMoreData {
    JBLOG(@"请求更多数据");
    __weak ViewController *weakSelf = self;
    //gcd 模仿请求数据延迟操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *moreDataArray = [weakSelf.dataArray mutableCopy];
        [weakSelf.dataArray addObjectsFromArray:moreDataArray];
        [weakSelf.myTableView reloadData];
        [weakSelf.myTableView.mj_footer endRefreshing];
    });

}

- (void)writeData {
    JBLOG(@"更新数据");
    NSTimeInterval oldTime = [NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:oldTime] forKey:@"updateData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //ViewModel
    JBNewsViewModel *jbNewsViewMidel = [[JBNewsViewModel alloc] init];
    __weak ViewController *weakSelf = self;
    //回调
    [jbNewsViewMidel setCallbackWithReturnCallBack:^(id returnValue) {
        weakSelf.dataArray = (NSMutableArray *)returnValue;
        [weakSelf.myTableView reloadData];
        [weakSelf writeDataToDiskWithArray:weakSelf.dataArray];
        
    } WithErrorCodeCallBack:^(id errorCode) {
        
    } WithFailureCallBack:^{
        
    }];
    
     //请求数据 触发回调
    [jbNewsViewMidel requestNewsData];

}

- (void)writeDataToDiskWithArray:(NSMutableArray *)array {
    
    for (JBNews *jbNews in array) {
        News *news = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:_context];
        //news.id = jbNews.jbNewsId;
        news.id = jbNews.id;
        JBLOG(@"%@",news.id);
        news.title = jbNews.title;
        news.descr = jbNews.descr;
        news.imgurl = jbNews.imgurl;
        NSError *error;
        if ([_context save:&error]) {
            JBLOG(@"保存数据成功");
        }else  {
            JBLOG(@"保存数据失败：%@",error.localizedDescription);
        }
    }
}

- (void)deleteData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"News"];
    NSArray *newSArray = [_context executeFetchRequest:fetchRequest error:nil];
    for (News *news in newSArray) {
        [_context deleteObject:news];
    }
    if ([_context save:nil]) {
        JBLOG(@"delete Data success");
    }
}

- (void)getDataInDisk {
    JBLOG(@"从本地获得数据");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"News"];
    NSArray *newsArray = [_context executeFetchRequest:fetchRequest error:nil];
    for (News *news in newsArray) {
        JBNews *jbNews = [[JBNews alloc] init];
        //jbNews.jbNewsId = news.id;
        jbNews.id = news.id;
        jbNews.title = news.title;
        jbNews.descr = news.descr;
        jbNews.imgurl = news.imgurl;
        [self.dataArray addObject:jbNews];
    }
    [self.myTableView reloadData];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}


#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray?self.dataArray.count:0;
}

//如果是xib代码自适应 这个代理方法可以不写  但是单元格比较复杂的话有点小卡 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JBNews *news =  self.dataArray[indexPath.row];
    //JBLOG(@"单元格高度：%f",news.cellHeight);
    return news.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       JBNews *jbNews = self.dataArray[indexPath.row];

//    JBAutolayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.newsModel = jbNews;

    
    JBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jbcell" forIndexPath:indexPath];
    cell.topLable.text = jbNews.title;
    cell.bottomLable.text = jbNews.descr;
    [cell.cellImgaeView sd_setImageWithURL:[NSURL URLWithString:jbNews.imgurl]];
    //JBLOG(@"%f",cell.frame.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JBNewsViewModel *jbNewsViewModel = [[JBNewsViewModel alloc] init];
    [jbNewsViewModel pushToNewsDetailViewControllerWithNews:self.dataArray[indexPath.row] WithRootViewController:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//在这里面可以传参数呀
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JBBuyViewController *buyViewController = segue.destinationViewController;
}

@end
