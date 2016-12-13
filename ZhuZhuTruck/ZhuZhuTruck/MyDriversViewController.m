//
//  MyDriversViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MyDriversViewController.h"
#import "CarStockViewController.h"
#import "OilCardsViewController.h"
#import "ETCCardsViewController.h"
#import "DriverCarDetailViewController.h"
@interface MyDriversViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyDriversViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSeletedMode) {
        [self addBlackNaviHaderViewWithTitle:@"分配车辆"];
    }else{
        [self addBlackNaviHaderViewWithTitle:@"我的车队"];
    }
    
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTableView];
    [self initBottomView];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    [self.dataArray addObjectsFromArray:@[@YES,@YES,@NO,@NO,@YES,@NO]];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-60) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DrvierCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DrvierCarCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    
    [self.view addSubview:self.tableView];
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DrvierCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrvierCarCell" forIndexPath:indexPath];
    if (self.isSeletedMode) {
        NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
        [cell showCellWithStatus:status.boolValue];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    headerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:lineView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSeletedMode) {
        NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
        status = [NSNumber numberWithBool:!status.boolValue];
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:status];
        [tableView reloadData];
    }else{
        DriverCarDetailViewController *carDetail = [[DriverCarDetailViewController alloc]init];
        [self.navigationController pushViewController:carDetail animated:YES];
    }
}

- (void)initBottomView{
    UIButton * sumbitButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    sumbitButton.backgroundColor = [UIColor buttonGreenColor];
    [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.isSeletedMode) {
        [sumbitButton setTitle:@"分配车辆" forState:UIControlStateNormal];
        [sumbitButton addTarget:self action:@selector(assginCar) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [sumbitButton setTitle:@"添加车辆" forState:UIControlStateNormal];
        [sumbitButton addTarget:self action:@selector(addNewCar) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:sumbitButton];
}

- (void)addNewCar{
    
}

- (void)assginCar{
    NSArray *viewControllers;
    NSArray *titles;
    NSString *title;
    viewControllers = @[[OilCardsViewController class],[ETCCardsViewController class]];
    titles = @[@"油卡",@"ETC卡"];
    title = @"我的卡劵";
    CarStockViewController *pageVC = [[CarStockViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.isSeletedMode = YES;
    pageVC.menuItemWidth = [UIScreen mainScreen].bounds.size.width/titles.count;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    pageVC.menuHeight = 36;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.menuBGColor = [UIColor naviBlackColor];
    pageVC.titleColorSelected = [UIColor whiteColor];
    pageVC.titleColorNormal = [UIColor colorWithWhite:0.9 alpha:0.8];
    pageVC.titleFontName = @"Helvetica-Bold";
    pageVC.titleSizeNormal = 18;
    pageVC.progressHeight = 4;
    pageVC.progressColor = [UIColor whiteColor];
    pageVC.pageAnimatable = YES;
    pageVC.titleSizeSelected = 18;
    pageVC.title = title;
    [self.navigationController pushViewController:pageVC animated:YES];

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
