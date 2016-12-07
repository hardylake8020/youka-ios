//
//  ETCCardsViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ETCCardsViewController.h"
#import "DriverCarDetailViewController.h"
@interface ETCCardsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ETCCardsViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"ETC卡";
    [self initTableView];
}
- (void)initTableView{
    
    [self.dataArray addObjectsFromArray:@[@NO,@NO,@YES,@NO,@YES,@YES]];
    if (self.isSeletedMode) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100-60)];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100)];
    }
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ETCCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ETCCardCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
}


#pragma mark ---> UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
    ETCCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ETCCardCell" forIndexPath:indexPath];
    if (self.isSeletedMode) {
        [cell showSeletedCellWithStatus:status.boolValue];
    }else{
        [cell showCellWithStatus:status.boolValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
    
    if (self.isSeletedMode) {
        NSNumber *status = [self.dataArray objectAtIndex:indexPath.section];
        status = [NSNumber numberWithBool:!status.boolValue];
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:status];
        [tableView reloadData];
        
    }else{
        if (status.boolValue) {
            DriverCarDetailViewController *carDetail = [[DriverCarDetailViewController alloc]init];
            [self.navigationController pushViewController:carDetail animated:YES];
        }
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
