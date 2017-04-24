//
//  MediatorTransportingViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorTransportingViewController.h"
#import "MediatorOrderDetailViewController.h"
#import "DriverTimeLineViewController.h"
@interface MediatorTransportingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@property (nonatomic, assign) int limit;//条数限制
@property (nonatomic, assign) int skipCount;//跳 过 几条
@property (nonatomic, assign) int totoalCount;// 总数
@property (nonatomic, assign) int currentPage;// 当前页
@end

@implementation MediatorTransportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 10;
    _currentPage = 0;
    _skipCount = 0;
    _totoalCount = 0;
    self.title = @"订单运输中";
    [self initTableView];
    [self initErrorMaskView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentPage = 0;
    [self loadNewData];
}


- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现运输中的订单";
    self.errMaskView.hidden = YES;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    
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
        weakself.currentPage = 0;
        [weakself loadNewData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
}

- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    _currentPage++;
    if (_currentPage==1) {
        _skipCount = 0;
    }else{
        _skipCount = (int)self.dataArray.count;
    }
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:@"inProgress" key:@"status"];
    [parameters putInt:_limit key:@"limit"];
    [parameters putInt:_skipCount key:@"current_count"];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:GET_TENDER_BY_STATUS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            if (weakself.currentPage==1) {
                //刷新
                [weakself.dataArray removeAllObjects];
            }

            NSArray *orders = [result objectForKey:@"tenders"];
            weakself.totoalCount = [result intForKey:@"totalCount"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)orders.count);
            
            for (NSDictionary *orderDict in orders) {
                TenderModel *tenderModel = [[TenderModel alloc]initWithDictionary:orderDict error:nil];
                [weakself.dataArray addObject:tenderModel];
            }
            
            [weakself.tableView reloadData];
        }
        if (weakself.dataArray.count==0) {
            weakself.errMaskView.hidden = NO;
        }else{
            weakself.errMaskView.hidden = YES;
        }
        [weakself.tableView.mj_header endRefreshing];
        if (self.dataArray.count >= weakself.totoalCount) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
    }];

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

    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.section];
    TenderSucceedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderSucceedCell" forIndexPath:indexPath];
    [cell showTenderCellWithTenderModel:tenderModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.section];
    if ([tenderModel.tender_type isEqualToString:@"grab"]) {
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:RobTenderSucceed andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else if([tenderModel.tender_type isEqualToString:@"compare"]){
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderSucceed andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else if([tenderModel.tender_type isEqualToString:@"compares_ton"]){
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:TonTenderSucceed andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:section];
    UIView *footerView = [[UIView alloc]init];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    [footerView addSubview:topLine];
    
    footerView.frame = CGRectMake(0, 0, SYSTEM_WIDTH, 50);
    
    UIButton *carNumberButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SYSTEM_WIDTH, 49)];
    [carNumberButton setBackgroundColor:[UIColor whiteColor]];
    [carNumberButton setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [carNumberButton setTitle:tenderModel.truck_number forState:UIControlStateNormal];
    carNumberButton.tag = 3000+section;
    [carNumberButton addTarget:self action:@selector(timeLine:) forControlEvents:UIControlEventTouchUpInside];
    carNumberButton.titleLabel.font = fontBysize(16);
    [footerView addSubview:carNumberButton];
    UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    centerLine.backgroundColor = [UIColor customGrayColor];
    

    [footerView addSubview:centerLine];
    if (section < self.dataArray.count-1) {
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SYSTEM_WIDTH, 0.5)];
        bottomLine.backgroundColor = [UIColor customGrayColor];
        [footerView addSubview:bottomLine];
    }
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)timeLine:(UIButton *)button{
    NSInteger tag = button.tag - 3000;
    TenderModel *tenderModel = [self.dataArray objectAtIndex:tag];
    DriverTimeLineViewController *timeLine = [[DriverTimeLineViewController alloc]initWithTenderId:tenderModel._id];
    [self.navigationController pushViewController:timeLine animated:YES];
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
