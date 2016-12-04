//
//  MediatorTransportingViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorTransportingViewController.h"
#import "MediatorOrderDetailViewController.h"
@interface MediatorTransportingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MediatorTransportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单运输中";
    [self initTableView];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    
    [self.dataArray addObjectsFromArray:@[@NO,@NO,@YES,@NO,@YES,@YES]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderSucceedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderSucceedCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    self.tableView.tableHeaderView = topLine;

    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
    //    [self tableHeaderRefesh];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    
}
#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderSucceedCell" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
    if (status.boolValue) {
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderSucceed];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:RobTenderSucceed];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    [footerView addSubview:topLine];
    
    footerView.frame = CGRectMake(0, 0, SYSTEM_WIDTH, 50);
    
    UIButton *carNumberButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SYSTEM_WIDTH, 49)];
    [carNumberButton setBackgroundColor:[UIColor whiteColor]];
    [carNumberButton setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [carNumberButton setTitle:@"沪B525N2" forState:UIControlStateNormal];
    
    carNumberButton.tag = 3000+section;
    [footerView addSubview:carNumberButton];
    
    
    UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    centerLine.backgroundColor = [UIColor customGrayColor];
    [footerView addSubview:centerLine];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SYSTEM_WIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor customGrayColor];
    [footerView addSubview:bottomLine];
    
    return footerView;
}

- (void)assignOrder:(UIButton *)button{
    //    NSInteger tag = button.tag - 3000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
