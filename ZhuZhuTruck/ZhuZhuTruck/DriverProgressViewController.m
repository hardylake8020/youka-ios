//
//  DriverProgressViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverProgressViewController.h"
#import "Constants.h"
#import "CCNaviHeaderView.h"
#import "HomePageViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface DriverProgressViewController ()

@end

@implementation DriverProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
}


- (void)naviBack{
    for (NSInteger i=self.navigationController.viewControllers.count-1; i>=0; i--) {
        UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:i];
        if ([VC isKindOfClass:[HomePageViewController class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
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
