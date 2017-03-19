//
//  DriverCarDetailViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverCarDetailViewController.h"
#import "CarDetailCell.h"
#import <UIImageView+WebCache.h>
#import "ShowPhotoViewController.h"
#import "TruckDetailTableDataModel.h"
@interface DriverCarDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TruckModel* truckModel;
@property (nonatomic, strong) DriverModel* driverModel;
@property (nonatomic, strong) TruckDetailTableDataModel * tableModel;
@property (nonatomic, copy) SucceedCallBack callBackHandler;
@end

@implementation DriverCarDetailViewController


- (instancetype)initWithTruckModel:(TruckModel *)model
{
    self = [super init];
    if (self) {
        self.truckModel = model;
        self.title = @"车辆详情";
    }
    return self;
}

- (instancetype)initWithDriverModel:(DriverModel *)model andSucceedCallBack:(SucceedCallBack)callBack{
    self = [super init];
    if (self) {
        self.driverModel = model;
        self.title = @"司机详情";
        self.callBackHandler = callBack;
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
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    
    if (self.driverModel&&self.callBackHandler) {
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [addButton addTarget:self action:@selector(addDrvier) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [naivHeader addRightButton:addButton];
    }
    
    [self initHeaderView];
    [self initTableView];
}

- (void)addDrvier{
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.driverModel._id key:@"driver_id"];
    
    
    [SVProgressHUD showWithStatus:@"正在添加..."];
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_ADD_DRIVERS_TO_OWNER parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"添加失败")];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            if (weakself.callBackHandler) {
                weakself.callBackHandler();
            }
            [weakself naviBack];
        }
    }];

}

- (void)initHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 200)];
    headerView.backgroundColor = [UIColor naviBlackColor];
    [self.view addSubview:headerView];
    UIImageView *carImageView = [[UIImageView alloc]init];
    if (self.driverModel) {
        if ([self.driverModel.photo isEqualToString:@""]) {
            self.driverModel.photo = nil;
        }
        [carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,self.driverModel.photo]]placeholderImage:[UIImage imageNamed:@"ic_head"] options:SDWebImageProgressiveDownload];
    }else{
        carImageView.image = [UIImage imageNamed:@"truck_car"];
    }
    [headerView addSubview:carImageView];
    
    carImageView.clipsToBounds = YES;
    carImageView.layer.cornerRadius = 70;
    
    carImageView.sd_layout
    .widthIs(140)
    .heightIs(140)
    .centerXEqualToView(headerView)
    .centerYEqualToView(headerView);
    
}
- (void)initTableView{
    
    if (self.truckModel) {
        self.tableModel = [[TruckDetailTableDataModel alloc]initWithTruckModel:self.truckModel];
    }
    if (self.driverModel) {
        self.tableModel = [[TruckDetailTableDataModel alloc]initWithDriverModel:self.driverModel];
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+200, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-200) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CarDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarDetailCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor customGrayColor]];
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
    return 50;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    headerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:lineView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TruckDetailCellModel *model = [[self.tableModel.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (model.isImage&&model.subTitle&&![model.subTitle isEmpty]) {
        ShowPhotoViewController *showPhoto = [[ShowPhotoViewController alloc]initWithFileName:model.subTitle];
        [self.navigationController pushViewController:showPhoto animated:YES];
    }
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
