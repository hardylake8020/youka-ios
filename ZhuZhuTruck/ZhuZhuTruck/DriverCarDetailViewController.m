//
//  DriverCarDetailViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverCarDetailViewController.h"
#import "CarDetailCell.h"
#import "TruckDetailTableDataModel.h"
@interface DriverCarDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TruckModel * truckModel;
@property (nonatomic, strong) TruckDetailTableDataModel * tableModel;
@end

@implementation DriverCarDetailViewController


- (instancetype)initWithTruckModel:(TruckModel *)model
{
    self = [super init];
    if (self) {
        self.truckModel = model;
    }
    return self;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"车辆详情"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderView];
    [self initTableView];
}
- (void)initHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 150)];
    headerView.backgroundColor = [UIColor naviBlackColor];
    [self.view addSubview:headerView];
    
    
    UIImageView *carImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"truck_car"]];
    [headerView addSubview:carImageView];
    
    carImageView.clipsToBounds = YES;
    carImageView.layer.cornerRadius = 50;
    
    carImageView.sd_layout
    .widthIs(100)
    .heightIs(100)
    .centerXEqualToView(headerView)
    .centerYEqualToView(headerView);
    
}
- (void)initTableView{
    
//    NSMutableArray *firstSectionArray = [NSMutableArray array];
//    [firstSectionArray addObject:@{@"title":@"车辆",@"subTitle":@"沪AA8888"}];
//    [firstSectionArray addObject:@{@"title":@"车型",@"subTitle":@"金杯"}];
//    [firstSectionArray addObject:@{@"title":@"油卡",@"subTitle":@"2222 5555 7777 9999"}];
//    [self.dataArray addObject:firstSectionArray];
//    
//    NSMutableArray *secondSectionArray = [NSMutableArray array];
//    [secondSectionArray addObject:@{@"title":@"司机",@"subTitle":@"Sisley"}];
//    [secondSectionArray addObject:@{@"title":@"司机手机",@"subTitle":@"16598767867"}];
//    [self.dataArray addObject:secondSectionArray];
//    
//    NSMutableArray *thirdSectionArray = [NSMutableArray array];
//    [thirdSectionArray addObject:@{@"title":@"状态",@"subTitle":@"运输中"}];
//    [thirdSectionArray addObject:@{@"title":@"当前位置",@"subTitle":@"上海浦东"}];
//    [self.dataArray addObject:thirdSectionArray];
    
    self.tableModel = [[TruckDetailTableDataModel alloc]initWithTruckModel:self.truckModel];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+150, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-150) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CarDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarDetailCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.1)];
}
#pragma mark ---> UITableViewDelegate dataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.tableModel.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TruckDetailCellModel *model = [[self.tableModel.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarDetailCell" forIndexPath:indexPath];
    [cell showCellWithCellModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    headerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:lineView];
    return headerView;
}

- (void)initButtonView{
    UIButton *pickupMarginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-80, SYSTEM_WIDTH, 80)];
    [pickupMarginButton  setTitle:@"提取保证金 ￥ 200.00" forState:UIControlStateNormal];
    [pickupMarginButton setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    pickupMarginButton.titleLabel.font = fontBysize(18);
    [self.view addSubview:pickupMarginButton];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor customGrayColor];
    [pickupMarginButton addSubview:topLine];
    
}
#pragma mark ---> 返回 其他
- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
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
