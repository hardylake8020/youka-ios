//
//  SettingViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviHeaderViewWithTitle:@"设置"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    self.dataArray = [NSArray array];
    [self initTableView];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellID"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettingCellID"];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 70)];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = UIColorFromRGB(0xcccccc);
    [footerView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, SYSTEM_WIDTH, 0.5)];
    lineView2.backgroundColor = UIColorFromRGB(0xcccccc);
    [footerView addSubview:lineView2];
    
    footerView.backgroundColor = _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);;
    UIButton *loginOutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, SYSTEM_WIDTH, 50)];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginOutButton.backgroundColor = [UIColor whiteColor];
    [loginOutButton addTarget:self action:@selector(quitAccount) forControlEvents:UIControlEventTouchUpInside];
    [loginOutButton setTitleColor:[UIColor customRedColor] forState:UIControlStateNormal];
    [footerView addSubview:loginOutButton];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, SYSTEM_WIDTH, 0.5)];
    lineView3.backgroundColor = UIColorFromRGB(0xcccccc);
    [footerView addSubview:lineView3];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

- (void)quitAccount{
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
        // this is the code that will be executed when the user taps "No"
        // this is optional... if you leave the action as nil, it won't do anything
        // but here, I'm showing a block just to show that you can use one if you want to.
    }];
    
    RIButtonItem *deleteItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        // this is the code that will be executed when the user taps "Yes"
        // delete the object in question...
        save_UserPwd(@"");
        save_AccessToken(@"");
//        [[DBManager sharedManager] deletedAllLocations];
//        [[LocationTracker defaultLoactionTarker] stopLocationTracking];
        [_weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告！退去可能导致用户信息丢失"
                                                        message:@"你确定要退去这个账号吗？"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:deleteItem, nil];
    [alertView show];
    
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
