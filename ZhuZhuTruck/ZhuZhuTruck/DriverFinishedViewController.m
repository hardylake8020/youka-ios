//
//  DriverFinishedViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
// 

#import "DriverFinishedViewController.h"
#import "DriverTimeLineViewController.h"
#import "DriverWayBillDetailViewController.h"
@interface DriverFinishedViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;

@end

@implementation DriverFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单已完成";
    [self initTableView];
    [self initErrorMaskView];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现已完成的运单";
    self.errMaskView.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllCompletedOrders]];
    [self.tableView reloadData];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WaybillCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WaybillCell"];
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
    NSArray *array = [[NSArray alloc] initWithObjects:@"completed",nil];
    [parameters putKey:array key:@"status"];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [[DiverHttpRequstManager requestManager] getWithRequestBodyString:GET_BYSTATUS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            NSArray *orders = [result objectForKey:@"orders"];
            NSMutableArray *orderModels = [NSMutableArray array];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)orders.count);
            
            for (NSDictionary *orderDict in orders) {
//                CCLog(@"%@",orderDict);
                OrderModel *orderModel = [[OrderModel alloc]initWithDictionary:orderDict error:nil];
                if (orderModel.delete_status.boolValue) {
                    [[DBManager sharedManager] deleteOrderWithOrderId:orderModel._id];
                }else{
                    [[DBManager sharedManager] insertOrderWithOrderModel:orderModel];
                    [orderModels addObject:orderModel];
                }
            }
            if (orderModels.count != [[DBManager sharedManager] readAllCompletedOrders].count) {
                [[DBManager sharedManager] deletAllOrdersWithStatus:@2];
                [[DBManager sharedManager ] inserOrdersWithOrders:orderModels];
            }
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllCompletedOrders]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *orderModel = [self.dataArray objectAtIndex:indexPath.section];
    WaybillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaybillCell" forIndexPath:indexPath];
    [cell showCellWithOrderModel:orderModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *orderModel = [self.dataArray objectAtIndex:indexPath.section];
    DriverWayBillDetailViewController *detail = [[DriverWayBillDetailViewController alloc]initWithWillbillStaus:SucceedDelvieryStatus andOrderModel:orderModel];
    [self.navigationController pushViewController:detail animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 45)];
    UIColor *startColor = UIColorFromRGB(0xf5f5f5);
    UIButton *timeLineButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 45)];
    [timeLineButton setBackgroundColor:startColor];
    [timeLineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [timeLineButton setTitle:@"时间轴" forState:UIControlStateNormal];
    timeLineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    timeLineButton.tag = 10000+section;
    [timeLineButton addTarget:self action:@selector(timeLine:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:timeLineButton];
    return footerView;
}

- (void)timeLine:(UIButton *)button{
    NSInteger tag = button.tag - 10000;
    OrderModel *model = [self.dataArray objectAtIndex:tag];
    DriverTimeLineViewController *timeLine = [[DriverTimeLineViewController alloc]initWithOrderModel:model];
    [self.navigationController pushViewController:timeLine animated:YES];
    
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
