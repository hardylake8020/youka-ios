//
//  DriverTimeLineViewController.m
//  
//
//  Created by CongCong on 2016/12/3.
//
//

#import "DriverTimeLineViewController.h"

@interface DriverTimeLineViewController ()

@end

@implementation DriverTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviHeaderViewWithTitle:@"设置"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
//    [self initTableView];

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
