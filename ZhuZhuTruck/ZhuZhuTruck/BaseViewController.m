//
//  BaseViewController.m
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)addNaviHeaderViewWithTitle:(NSString *)title{
    self.title = title;
    self.naviHeaderView  = [[CCNaviHeaderView alloc]newInstance:title];
    [self.view addSubview:self.naviHeaderView];
}
- (void)addBlackNaviHaderViewWithTitle:(NSString *)title{
    self.title = title;
    self.naviHeaderView  = [[CCNaviHeaderView alloc]newInstance:title andBackGruondColor:[UIColor naviBlackColor]];
    [self.view addSubview:self.naviHeaderView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)dealloc{
    CCLog(@"%@------->delloc",self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
