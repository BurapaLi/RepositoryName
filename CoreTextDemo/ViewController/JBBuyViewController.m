//
//  JBBuyViewController.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/2.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "JBBuyViewController.h"
#import "JBChoseGoodsView.h"
#import "JBGoodsTypeView.h"
#import "JBBuyGoodsCountView.h"
@interface JBBuyViewController () {
    UIView *bgview;
    CGPoint center;
    NSArray *sizearr;//型号数组
    NSArray *colorarr;//分类数组
    NSDictionary *stockarr;//商品库存量
    int goodsStock;

}

@property (nonatomic,strong) JBChoseGoodsView *choseGoodsView;
@end

@implementation JBBuyViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"仿淘宝购物";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    sizearr = [[NSArray alloc] initWithObjects:@"S",@"M",@"L",nil];
    colorarr = [[NSArray alloc] initWithObjects:@"蓝色",@"红色",@"湖蓝色",@"咖啡色",nil];
    NSString *str = [[NSBundle mainBundle] pathForResource: @"stock" ofType:@"plist"];
    //stockarr = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str]];
    stockarr = [[NSDictionary alloc] initWithContentsOfFile:str];
    [self setUpSubViews];
}

- (void)setUpSubViews {
    /**
     *  商品信息页面内容
     */
    self.view.backgroundColor = [UIColor blackColor];
    //淘宝点击加入购物车时商品信息页面会缩小，中心点上移，背景为黑色，弹出视图为全屏，露出的一部分商品信息页面也有一层很浅的黑色透明视图盖着，所以我对商品信息页面做了以下布局，上导航栏隐藏，self.view作为那个黑色背景，bgview盖在self.view上，所有商品信息都在bgview上，choseView是弹出视图，放在屏幕下方，当点击加入购物车时从下方进入，同时bgview缩小，中心点上移
    bgview = [[UIView alloc] initWithFrame:self.view.bounds];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UIButton *btn_add= [UIButton buttonWithType:UIButtonTypeCustom];
    btn_add.frame = CGRectMake(100, 80,200, 50);
    btn_add.center = CGPointMake(self.view.center.x, 90);
    [btn_add setTitleColor:[UIColor whiteColor] forState:0];
    btn_add.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn_add setTitle:@"加入购物车" forState:0];
    btn_add.backgroundColor = [UIColor redColor];
    btn_add.layer.cornerRadius = 4;
    btn_add.layer.borderColor = [UIColor clearColor].CGColor;
    btn_add.layer.borderWidth = 1;
    [btn_add.layer setMasksToBounds:YES];
    [btn_add addTarget:self action:@selector(btnselete) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:btn_add];

    [self initChoseGoodsView];
   
}

- (void)initChoseGoodsView {
    self.choseGoodsView = [[JBChoseGoodsView alloc] initWithFrame:CGRectMake(0, KHEIGHT, KWIDTH, KHEIGHT)];
    [self.view addSubview:self.choseGoodsView];
    //尺码
    __weak JBBuyViewController *weakSelf = self;
    self.choseGoodsView.sizeTypeView = [[JBGoodsTypeView alloc] initWithFrame:CGRectMake(0, 0, self.choseGoodsView.frame.size.width, 50) dataSource:sizearr typeName:@"尺码"];
    self.choseGoodsView.sizeTypeView.callBack = ^(int selectIndex){
        [weakSelf selectBtnAtIndex:selectIndex];
    };
    [self.choseGoodsView.mainGoodsMessageView addSubview:self.choseGoodsView.sizeTypeView];
    self.choseGoodsView.sizeTypeView.frame = CGRectMake(0, 0, self.choseGoodsView.frame.size.width, self.choseGoodsView.sizeTypeView.height);
    //颜色分类
    self.choseGoodsView.colorTypeView = [[JBGoodsTypeView alloc] initWithFrame:CGRectMake(0, self.choseGoodsView.sizeTypeView.frame.size.height, self.choseGoodsView.sizeTypeView.frame.size.width, 50)  dataSource:colorarr typeName:@"选择颜色"];
    
    self.choseGoodsView.colorTypeView.callBack = ^(int selectIndex) {
        [weakSelf selectBtnAtIndex:selectIndex];
    };
    [self.choseGoodsView.mainGoodsMessageView addSubview:self.choseGoodsView.colorTypeView];
    self.choseGoodsView.colorTypeView.frame = CGRectMake(0, self.choseGoodsView.sizeTypeView.frame.size.height, self.choseGoodsView.frame.size.width, self.choseGoodsView.colorTypeView.height);
    //购买数量
    self.choseGoodsView.jbBuyGoodsCountView.frame = CGRectMake(0, self.choseGoodsView.colorTypeView.frame.size.height+self.choseGoodsView.colorTypeView.frame.origin.y, self.choseGoodsView.frame.size.width, 50);
    self.choseGoodsView.mainGoodsMessageView.contentSize = CGSizeMake(self.view.frame.size.width, self.choseGoodsView.jbBuyGoodsCountView.frame.size.height+self.choseGoodsView.jbBuyGoodsCountView.frame.origin.y);

    self.choseGoodsView.priceLabel.text =@"167";
    self.choseGoodsView.stockLabel.text = @"库存1223件";
    self.choseGoodsView.choseGoodsdetailLabel.text = @"请选择 尺码 颜色分类";
    
    [self.choseGoodsView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.choseGoodsView.sureBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.choseGoodsView.alphaiView addGestureRecognizer:tap];
    //点击图片放大图片
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    self.choseGoodsView.goodsImageView.userInteractionEnabled = YES;
    [self.choseGoodsView.goodsImageView addGestureRecognizer:tap1];
}

- (void)showBigImage:(UITapGestureRecognizer *)tap {
    JBLOG(@"放大图片");
}


- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectBtnAtIndex:(int)index {
    //通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    if (self.choseGoodsView.sizeTypeView.selectIndex >=0&&self.choseGoodsView.colorTypeView.selectIndex >=0) {
        //尺码和颜色都选择的时候
        NSString *size =[sizearr objectAtIndex:self.choseGoodsView.sizeTypeView.selectIndex];
        NSString *color =[colorarr objectAtIndex:self.choseGoodsView.colorTypeView.selectIndex];
        self.choseGoodsView.stockLabel.text = [NSString stringWithFormat:@"库存%@件",[[stockarr objectForKey: size] objectForKey:color]];
        self.choseGoodsView.choseGoodsdetailLabel.text = [NSString stringWithFormat:@"已选 \"%@\" \"%@\"",size,color];
        self.choseGoodsView.stock =[[[stockarr objectForKey: size] objectForKey:color] intValue];
        
        [self reloadTypeBtn:[stockarr objectForKey:size] :colorarr :self.choseGoodsView.colorTypeView];
        [self reloadTypeBtn:[stockarr objectForKey:color] :sizearr :self.choseGoodsView.sizeTypeView];
        JBLOG(@"%d",self.choseGoodsView.colorTypeView.selectIndex);
        self.choseGoodsView.goodsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.choseGoodsView.colorTypeView.selectIndex+1]];
    }else if (self.choseGoodsView.sizeTypeView.selectIndex ==-1&&self.choseGoodsView.colorTypeView.selectIndex == -1)
    {
        //尺码和颜色都没选的时候
        self.choseGoodsView.priceLabel.text = @"¥100";
        self.choseGoodsView.stockLabel.text = @"库存100000件";
        self.choseGoodsView.choseGoodsdetailLabel.text = @"请选择 尺码 颜色分类";
        self.choseGoodsView.stock = 100000;
        //全部恢复可点击状态
        [self resumeBtn:colorarr :self.choseGoodsView.colorTypeView];
        [self resumeBtn:sizearr :self.choseGoodsView.sizeTypeView];
        
    }else if (self.choseGoodsView.sizeTypeView.selectIndex ==-1&&self.choseGoodsView.colorTypeView.selectIndex >= 0)
    {
        //只选了颜色
        NSString *color =[colorarr objectAtIndex:self.choseGoodsView.colorTypeView.selectIndex];
        //根据所选颜色 取出该颜色对应所有尺码的库存字典
        NSDictionary *dic = [stockarr objectForKey:color];
        [self reloadTypeBtn:dic :sizearr :self.choseGoodsView.sizeTypeView];
        [self resumeBtn:colorarr :self.choseGoodsView.colorTypeView];
        self.choseGoodsView.stockLabel.text = @"库存100000件";
        self.choseGoodsView.choseGoodsdetailLabel.text = @"请选择 尺码";
        self.choseGoodsView.stock = 100000;
        
        self.choseGoodsView.goodsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.choseGoodsView.colorTypeView.selectIndex+1]];
    }else if (self.choseGoodsView.sizeTypeView.selectIndex >= 0&&self.choseGoodsView.colorTypeView.selectIndex == -1)
    {
        //只选了尺码
        NSString *size =[sizearr objectAtIndex:self.choseGoodsView.sizeTypeView.selectIndex];
        //根据所选尺码 取出该尺码对应所有颜色的库存字典
        NSDictionary *dic = [stockarr objectForKey:size];
        [self resumeBtn:sizearr :self.choseGoodsView.sizeTypeView];
        [self reloadTypeBtn:dic :colorarr :self.choseGoodsView.colorTypeView];
        self.choseGoodsView.stockLabel.text = @"库存100000件";
        self.choseGoodsView.choseGoodsdetailLabel.text = @"请选择 颜色分类";
        self.choseGoodsView.stock = 100000;
        
        //        for (int i = 0; i<colorarr.count; i++) {
        //            int count = [[dic objectForKey:[colorarr objectAtIndex:i]] intValue];
        //            //遍历颜色字典 库存为零则改尺码按钮不能点击
        //            if (count == 0) {
        //                UIButton *btn =(UIButton *) [choseView.colorView viewWithTag:100+i];
        //                btn.enabled = NO;
        //            }
        //        }
        
    }

}

/**
 *  点击按钮弹出
 */
-(void)btnselete
{
    [self.navigationController setNavigationBarHidden:YES];
    [UIView animateWithDuration: 0.35 animations: ^{
        bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        bgview.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        self.choseGoodsView.center = self.view.center;
        self.choseGoodsView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
    
    
}

/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    [self.navigationController setNavigationBarHidden:NO];
    //center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        self.choseGoodsView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
        bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        bgview.center = self.view.center;
    } completion: nil];
    
}

//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(JBGoodsTypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (view.selectIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}
//根据所选的尺码或者颜色对应库存量 确定哪些按钮不可选
-(void)reloadTypeBtn:(NSDictionary *)dic :(NSArray *)arr :(JBGoodsTypeView *)view
{
    for (int i = 0; i<arr.count; i++) {
        int count = [[dic objectForKey:[arr objectAtIndex:i]] intValue];
        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        //库存为零 不可点击
        if (count == 0) {
            btn.enabled = NO;
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        }else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.selectIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}


//- (void)btnselete {
//    JBLOG(@"加入购物车");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
