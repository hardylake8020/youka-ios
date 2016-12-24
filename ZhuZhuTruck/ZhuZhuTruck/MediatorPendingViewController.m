//
//  MediatorPendingViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorPendingViewController.h"
#import "MyDriversViewController.h"
#import "MediatorOrderDetailViewController.h"
@interface MediatorPendingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation MediatorPendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单待处理";
    [self initTableView];
    [self initErrorMaskView];
}


- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现待处理的订单";
    self.errMaskView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderProcessCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderProcessCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderSucceedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderSucceedCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    self.tableView.tableHeaderView = topLine;
    [self.view addSubview:self.tableView];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
    //    [self tableHeaderRefesh];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
//    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [tableView.mj_footer endRefreshing];
//        });
//    }];
}

- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
#warning 分页
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:@"unAssigned" key:@"status"];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:GET_TENDER_BY_STATUS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            NSArray *orders = [result objectForKey:@"tenders"];
            [weakself.dataArray removeAllObjects];
            CCLog(@"UnpickOrderCount------------->:%ld",orders.count);
            
            for (NSDictionary *orderDict in orders) {
                //                CCLog(@"%@",orderDict);
                
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
        [weakself.tableView.mj_footer endRefreshing];
    }];

}
#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.section];
    if ([tenderModel.status isEqualToString:@"unAssigned"]) {
        return 160;
    }
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:section];
    if ([tenderModel.status isEqualToString:@"unAssigned"]) {
        return 60;
    }
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.section];
    TenderProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderProcessCell" forIndexPath:indexPath];
    [cell showTenderCellWithTenderModel:tenderModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.section];
    if ([tenderModel.tender_type isEqualToString:@"grab"]) {
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:RobTenderSucceed andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderOngoing];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:section];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 50)];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    [footerView addSubview:topLine];
    
    if ([tenderModel.status isEqualToString:@"unAssigned"]) {
        UIButton *assignButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SYSTEM_WIDTH, 49)];
        [assignButton setBackgroundColor:[UIColor whiteColor]];
        [assignButton setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
        [assignButton setTitle:@"分配车辆" forState:UIControlStateNormal];
        assignButton.tag = 2000+section;
        [assignButton addTarget:self action:@selector(assignOrder:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:assignButton];
        
        UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
        centerLine.backgroundColor = [UIColor customGrayColor];
        [footerView addSubview:centerLine];
        
        if (section < self.dataArray.count-1) {
            UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SYSTEM_WIDTH, 0.5)];
            bottomLine.backgroundColor = [UIColor customGrayColor];
            [footerView addSubview:bottomLine];
        }
    }else{
        footerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        if (section < self.dataArray.count-1) {
            UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SYSTEM_WIDTH, 0.5)];
            bottomLine.backgroundColor = [UIColor customGrayColor];
            [footerView addSubview:bottomLine];
        }
    }
    return footerView;
}

- (void)assignOrder:(UIButton *)button{
    NSInteger tag = button.tag - 2000;
    TenderModel *tenderModel = [self.dataArray objectAtIndex:tag];
    MyDriversViewController *myDrvier = [[MyDriversViewController alloc]initWithAssaginTenderModel:tenderModel];
    [self.navigationController pushViewController:myDrvier animated:YES];
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
