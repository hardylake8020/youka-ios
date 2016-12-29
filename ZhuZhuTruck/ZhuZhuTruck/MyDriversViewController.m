//
//  MyDriversViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MyDriversViewController.h"
#import "TruckModel.h"
#import "CarStockViewController.h"
#import "OilCardsViewController.h"
#import "ETCCardsViewController.h"
#import "AddTruckCarViewController.h"
#import "DriverCarDetailViewController.h"
@interface MyDriversViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TenderModel *tenderModel;
@property (nonatomic, strong) TruckModel  *seletedTruck;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation MyDriversViewController

- (id)initWithAssaginTenderModel:(TenderModel*)tenderModel{
    self = [super init];
    if (self) {
        self.isSeletedMode = YES;
        self.tenderModel = tenderModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CCNaviHeaderView *naivHeader;
    
    if (self.isSeletedMode) {
        self.title = @"分配车辆";
        naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
        self.fd_interactivePopDisabled = YES;
        [self initBottomView];
    }else{
        self.title = @"我的车队";
        naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [addButton addTarget:self action:@selector(addNewCar) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [naivHeader addRightButton:addButton];
    }
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    
    [self initTableView];
    [self initErrorMaskView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}


- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发车辆";
    self.errMaskView.hidden = YES;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    if (self.isSeletedMode) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-50) style:UITableViewStyleGrouped];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT) style:UITableViewStyleGrouped];
    }
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DrvierCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DrvierCarCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    [self.tableView setSeparatorColor:[UIColor customGrayColor]];
    [self.view addSubview:self.tableView];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
//    [self tableHeaderRefesh];
    
}

- (void)loadNewData{
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GET_TRUCK_LIST parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            [weakself.dataArray removeAllObjects];
            NSArray *trucks = [result objectForKey:@"trucks"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)trucks.count);
            for (NSDictionary *truckDict in trucks) {
                TruckModel *model = [[TruckModel alloc]initWithDictionary:truckDict error:nil];
                if (weakself.isSeletedMode&&model.card) {
                    
                }else{
                    [weakself.dataArray addObject:model];
                }
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


- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}




#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TruckModel *truckModel = [self.dataArray objectAtIndex:indexPath.section];
    DrvierCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrvierCarCell" forIndexPath:indexPath];
    if (self.isSeletedMode) {
        [cell showSeletedTruckCellWithModel:truckModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        [cell showTruckCellWithModel:truckModel];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    headerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TruckModel *truckModel = [self.dataArray objectAtIndex:indexPath.section];
    if (self.seletedTruck) {
        self.seletedTruck.isSeleted = @NO;
    }
    if (self.isSeletedMode) {
        truckModel.isSeleted = @YES;
        self.seletedTruck = truckModel;
        [tableView reloadData];
    }else{
        DriverCarDetailViewController *carDetail = [[DriverCarDetailViewController alloc]initWithTruckModel:truckModel];
        [self.navigationController pushViewController:carDetail animated:YES];
    }
}

- (void)initBottomView{
    UIButton * sumbitButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50)];
    sumbitButton.backgroundColor = [UIColor buttonGreenColor];
    [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sumbitButton setTitle:@"分配车辆" forState:UIControlStateNormal];
    [sumbitButton addTarget:self action:@selector(assginCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitButton];
}

- (void)addNewCar{
    AddTruckCarViewController *addTruck = [[AddTruckCarViewController alloc]init];
    [self.navigationController pushViewController:addTruck animated:YES];
}

- (void)assginCar{
    
    NSMutableArray *seletedTrucks = [NSMutableArray array];
    for (TruckModel *truckModel in self.dataArray) {
        if (truckModel.isSeleted.boolValue) {
            
            if (![truckModel.truck_type isEqualToString:self.tenderModel.truck_type]) {
                toast_showInfoMsg(@"车辆类型与要求不匹配", 200);
                return;
            }
            [seletedTrucks addObject:truckModel];
        }
    }
    if (!self.seletedTruck) {
        toast_showInfoMsg(@"请选择一个车辆", 200);
        return;
    }
    if (![self.seletedTruck.truck_type isEqualToString:self.tenderModel.truck_type]) {
        toast_showInfoMsg(@"车辆类型与要求不匹配", 200);
        return;
    }
    OilCardsViewController *card = [[OilCardsViewController alloc]initWithTenderModel:self.tenderModel andTruckModel:self.seletedTruck];
    [self.navigationController pushViewController:card animated:YES];

}

#pragma mark ---> 返回 其他

- (void)naviBack{
    if (self.isFormDetail) {
        
        NSInteger pageIndex = self.navigationController.viewControllers.count;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:pageIndex-3] animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
