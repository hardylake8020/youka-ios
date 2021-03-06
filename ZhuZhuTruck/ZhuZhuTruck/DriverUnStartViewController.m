//
//  DriverUnStartViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverUnStartViewController.h"
#import "NSString+Tool.h"
#import "DriverOperationViewController.h"
#import "DriverWayBillDetailViewController.h"
@interface DriverUnStartViewController ()<UITableViewDelegate, UITableViewDataSource>{
    AddressManager *_addressManager;
}
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation DriverUnStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单待提货";
    [self initTableView];
    [self initErrorMaskView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:RELOAD_DRIVER_ORDER_LIST_NOTI object:nil];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现待提货的运单";
    self.errMaskView.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self getAddress];
    if (self.dataArray.count ==0) {
        [self tableHeaderRefesh];
    }
}

- (void)reloadData{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllUnpickupOrders]];
    [self.tableView reloadData];
}

- (void)getAddress{
    _addressManager = [AddressManager sharedManager];
    CCWeakSelf(self);
    [_addressManager getCurentAddressWithCallBackHandler:^(NSString *address, CLLocationCoordinate2D location) {
        weakself.address = address;
        weakself.userLocation = location;
    }];
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
    NSArray *array = [[NSArray alloc] initWithObjects:@"unPickupSigned",@"unPickuped",nil];
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
            if (orderModels.count != [[DBManager sharedManager] readAllUnpickupOrders].count) {
                [[DBManager sharedManager] deletAllOrdersWithStatus:@0];
                [[DBManager sharedManager ] inserOrdersWithOrders:orderModels];
            }
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:[[DBManager sharedManager] readAllUnpickupOrders]];
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
    
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *orderModel = [self.dataArray objectAtIndex:indexPath.section];
    WaybillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaybillCell" forIndexPath:indexPath];
    [cell showCellWithOrderModel:orderModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *orderModel = [self.dataArray objectAtIndex:indexPath.section];
    if (![orderModel.confirm_status isEqualToString:@"confirmed"]){
        toast_showInfoMsg(@"请先发车启动", 200);
        return;
    }
    DriverWayBillDetailViewController *detail = [[DriverWayBillDetailViewController alloc]initWithWillbillStaus:UnpickupedStatus andOrderModel:orderModel];
    [self.navigationController pushViewController:detail animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, SYSTEM_WIDTH+2, 40)];
    
    footerView.layer.borderColor = [UIColor customGrayColor].CGColor;
    footerView.layer.borderWidth = 0.5;
    OrderModel *orderModel = [self.dataArray objectAtIndex:section];
    
    UIColor *startColor = UIColorFromRGB(0xf5f5f5);
    UIColor *enterColor = UIColorFromRGB(0xf9f9f9);
    if (![orderModel.confirm_status isEqualToString:@"confirmed"]) {
        UIButton *carStartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 40)];
        [carStartButton setBackgroundColor:startColor];
        [carStartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [carStartButton setTitle:@"发车启动" forState:UIControlStateNormal];
        carStartButton.titleLabel.font = [UIFont systemFontOfSize:14];
        carStartButton.tag = 5000+section;
        [carStartButton addTarget:self action:@selector(startCar:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:carStartButton];
    }
    else{
        UIButton *pickupSignButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/3, 39)];
        [pickupSignButton setBackgroundColor:enterColor];
        [pickupSignButton setTitle:@"进场" forState:UIControlStateNormal];
        pickupSignButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pickupSignButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        pickupSignButton.tag = 6000+section;
        [pickupSignButton addTarget:self action:@selector(pickupSign:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:pickupSignButton];
        
        UIButton *pickupSucceedButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3, 0, SYSTEM_WIDTH/3*2, 40)];
        [pickupSucceedButton setBackgroundColor:startColor];
        [pickupSucceedButton setTitle:@"提货离场" forState:UIControlStateNormal];
        pickupSucceedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pickupSucceedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pickupSucceedButton.tag = 7000+section;
        [pickupSucceedButton addTarget:self action:@selector(pickupSucceed:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:pickupSucceedButton];
    }
    
    return footerView;
}

- (void)startCar:(UIButton *)button{
    if (_userLocation.latitude==0) {
        alert_showInfoMsg(@"还没有得到位置，请稍后再试");
        return;
    }
    if (!_address||[_address isEmpty]) {
        [self getAddress];
        _address = @"";
    }
    
    NSInteger tag = button.tag - 5000;
    OrderModel *orderModel = [self.dataArray objectAtIndex:tag];
    
    NSMutableDictionary *confirReport = [[NSMutableDictionary alloc]init];
    [confirReport put:orderModel._id key:@"order_id"];
    [confirReport put:accessToken() key:@"access_token"];
    [confirReport put:now() key:@"time"];
    [confirReport put:@"confirm" key:@"type"];
    [confirReport put:_address key:@"address"];
    [confirReport put:[NSNumber numberWithFloat:_userLocation.latitude] key:@"latitude"];
    [confirReport put:[NSNumber numberWithFloat:_userLocation.longitude] key:@"longitude"];
    NSNumber *time = [NSNumber numberWithDouble:[[SeverTimeManager defaultManager] currentTimeIntervarl]*1000];
    [confirReport put:time key:@"time"];
    
    [SVProgressHUD showWithStatus:@"发车启动..."];
    CCWeakSelf(self);
    [[DiverHttpRequstManager requestManager] postWithRequestBodyString:UPLOADEVENT parameters:confirReport resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"请求失败")];
            if ([error.domain isEqualToString:@"can_not_execute_confirm"]) {
                orderModel.confirm_status = @"confirmed";
                [[DBManager sharedManager] orderConfirmSucceedWithOrder:orderModel];
                [weakself.tableView reloadData];
            }
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发车成功"];
            orderModel.confirm_status = @"confirmed";
            [[DBManager sharedManager] orderConfirmSucceedWithOrder:orderModel];
            [weakself.tableView reloadData];
        }
    }];
    
    
}
- (void)pickupSign:(UIButton *)button{
    NSInteger tag = button.tag - 6000;
    OrderModel *orderModel = [self.dataArray objectAtIndex:tag];
    if ([orderModel.status isEqualToString:@"unPickuped"]) {
        toast_showInfoMsg(@"已经进过场了", 200);
        return;
    }
    DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSign andOrderModel:orderModel];
    [self.navigationController pushViewController:operation animated:YES];
}
- (void)pickupSucceed:(UIButton *)button{
    NSInteger tag = button.tag - 7000;
    OrderModel *orderModel = [self.dataArray objectAtIndex:tag];
    
    if (orderModel.pickup_photo_force.boolValue&&[orderModel.status isEqualToString:@"unPickupSigned"]) {
        __weak typeof(self) _weakSelf = self;
        RIButtonItem *pickUpsign = [RIButtonItem itemWithLabel:@"进场" action:^{
            DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSign andOrderModel:orderModel];
            [_weakSelf.navigationController pushViewController:operation animated:YES];
        }];
        
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
            
        }];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                            message:@"你还没提货进场，请先提货进场！"
                                                   cancelButtonItem:nil
                                                   otherButtonItems:cancelItem,pickUpsign, nil];
        [alertView show];
        
    }else{
        DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSucceed andOrderModel:orderModel];
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
