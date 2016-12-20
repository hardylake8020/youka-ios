//
//  DriverOngoingViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverOngoingViewController.h"
#import "DriverOperationViewController.h"
#import "DriverWayBillDetailViewController.h"
@interface DriverOngoingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DriverOngoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单运输中";
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:RELOAD_DRIVER_ORDER_LIST_NOTI object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
//    if (self.dataArray.count ==0) {
//        [self tableHeaderRefesh];
//    }
}

- (void)reloadData{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllUnpickupOrders]];
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
    NSArray *array = [[NSArray alloc] initWithObjects:@"unDeliverySigned",@"unDeliveried",nil];
    [parameters putKey:array key:@"status"];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [[HttpRequstManager requestManager] getWithRequestBodyString:GET_BYSTATUS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
        }else{
            //CCLog(@"---->%@",result);
            NSArray *orders = [result objectForKey:@"orders"];
            NSMutableArray *orderModels = [NSMutableArray array];
            CCLog(@"UnpickOrderCount------------->:%ld",orders.count);
            
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
            if (orderModels.count != [[DBManager sharedManager] readAllUnDeliveryOrders].count) {
                [[DBManager sharedManager] deletAllOrdersWithStatus:@1];
                [[DBManager sharedManager ] inserOrdersWithOrders:orderModels];
            }
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllUnDeliveryOrders]];
            [weakself.tableView reloadData];
        }
        if (weakself.dataArray.count==0) {
            //            weakself.errMaskView.hidden = NO;
        }else{
            //            weakself.errMaskView.hidden = YES;
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
    DriverWayBillDetailViewController *detail = [[DriverWayBillDetailViewController alloc]initWithWillbillStaus:UndeliveryedStatus andOrderModel:orderModel];
    [self.navigationController pushViewController:detail animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 45)];
    UIColor *startColor = UIColorFromRGB(0xf5f5f5);
    UIColor *enterColor = UIColorFromRGB(0xf9f9f9);
    UIButton *deliverySignButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/3, 44)];
    [deliverySignButton setBackgroundColor:enterColor];
    [deliverySignButton setTitle:@"进场" forState:UIControlStateNormal];
    deliverySignButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [deliverySignButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    deliverySignButton.tag = 8000+section;
    [deliverySignButton addTarget:self action:@selector(deliverySign:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deliverySignButton];
    
    UIButton *deliverySucceedButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3, 0, SYSTEM_WIDTH/3*2, 45)];
    [deliverySucceedButton setBackgroundColor:startColor];
    [deliverySucceedButton setTitle:@"交货完成" forState:UIControlStateNormal];
    deliverySucceedButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [deliverySucceedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deliverySucceedButton.tag = 9000+section;
    [deliverySucceedButton addTarget:self action:@selector(deliverySucceed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deliverySucceedButton];
    
    return footerView;
}
- (void)deliverySign:(UIButton *)button{
    NSInteger tag = button.tag - 8000;
    OrderModel *orderModel = [self.dataArray objectAtIndex:tag];
    if ([orderModel.status isEqualToString:@"unDeliveried"]) {
        toast_showInfoMsg(@"已经进过场了", 200);
        return;
    }
    DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:DeliveySign andOrderModel:orderModel];
    [self.navigationController pushViewController:operation animated:YES];
}
- (void)deliverySucceed:(UIButton *)button{
    NSInteger tag = button.tag - 9000;
    OrderModel *orderModel = [self.dataArray objectAtIndex:tag];
    
    if (orderModel.delivery_entrance_force.boolValue) {
        __weak typeof(self) _weakSelf = self;
        RIButtonItem *pickUpsign = [RIButtonItem itemWithLabel:@"进场" action:^{
            
        }];
        
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
            DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSign andOrderModel:orderModel];
            [_weakSelf.navigationController pushViewController:operation animated:YES];
        }];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                            message:@"你还没交货进场，请先进场！"
                                                   cancelButtonItem:nil
                                                   otherButtonItems:cancelItem,pickUpsign, nil];
        [alertView show];
        
    }else{
        DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:DeliveySucceed andOrderModel:orderModel];
        [self.navigationController pushViewController:operation animated:YES];
    }
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
