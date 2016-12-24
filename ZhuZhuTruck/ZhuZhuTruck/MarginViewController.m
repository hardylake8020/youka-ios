//
//  MarginViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MarginViewController.h"
#import "MarginCell.h"
@interface MarginViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MarginViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保证金";
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc] newInstance:self.title andBackGruondColor:[UIColor buttonGreenColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    [self initHeaderView];
    [self initTableView];
    [self initButtonView];
}
- (void)initHeaderView{
    [self.dataArray addObjectsFromArray:@[@YES,@YES]];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 150)];
    headerView.backgroundColor = [UIColor buttonGreenColor];
    [self.view addSubview:headerView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, SYSTEM_WIDTH-30, 20)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = fontBysize(18);
    tipLabel.text = @"已缴纳";
    [headerView addSubview:tipLabel];
    
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+150, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-150-80) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MarginCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarginCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.1)];
}
#pragma mark ---> UITableViewDelegate dataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarginCell" forIndexPath:indexPath];
    return cell;
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
