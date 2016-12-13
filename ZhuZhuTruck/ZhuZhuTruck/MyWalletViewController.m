//
//  MyWalletViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WalletCell.h"
#import "MarginViewController.h"
@interface MyWalletViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyWalletViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"我的钱包"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderView];
    [self initTableView];
}
- (void)initHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 140)];
    headerView.backgroundColor = [UIColor naviBlackColor];
    [self.view addSubview:headerView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SYSTEM_WIDTH-30, 20)];
    tipLabel.textColor = [UIColor customGrayColor];
    tipLabel.font = fontBysize(16);
    tipLabel.text = @"账户余额（元）";
    [headerView addSubview:tipLabel];
    
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, SYSTEM_WIDTH-30, 100)];
    accountLabel.textColor = [UIColor whiteColor];
    accountLabel.font = fontBysize(60);
    accountLabel.text = @"2000.00";
    [headerView addSubview:accountLabel];
    
}

- (void)initTableView{
    
    NSMutableArray *firstSectionArray = [NSMutableArray array];
    [firstSectionArray addObject:@{@"imageName":@"bankCard",@"titleName":@"银行卡"}];
    [firstSectionArray addObject:@{@"imageName":@"bankCard",@"titleName":@"充值"}];
    [firstSectionArray addObject:@{@"imageName":@"bankCard",@"titleName":@"提现"}];
    [self.dataArray addObject:firstSectionArray];
    
    NSMutableArray *secondSectionArray = [NSMutableArray array];
    [secondSectionArray addObject:@{@"imageName":@"bankCard",@"titleName":@"保证金"}];
    [secondSectionArray addObject:@{@"imageName":@"bankCard",@"titleName":@"账单"}];
    [self.dataArray addObject:secondSectionArray];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+140, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-140)];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WalletCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDict = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletCell" forIndexPath:indexPath];
    [cell showCellWithDataDict:dataDict];
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    footerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:lineView];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDict = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[dataDict stringForKey:@"titleName"] isEqualToString:@"保证金"]) {
        MarginViewController *margin = [[MarginViewController alloc]init];
        [self.navigationController pushViewController:margin animated:YES];
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
