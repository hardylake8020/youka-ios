//
//  CarStockViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CarStockViewController.h"
#import "Constants.h"
#import "CCNaviHeaderView.h"
#import "AddCardViewController.h"
#import "OilCardsViewController.h"
#import "ETCCardsViewController.h"
#import "DriverUnStartViewController.h"
#import "DriverOngoingViewController.h"
#import "DriverFinishedViewController.h"
#import "DriverProgressViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface CarStockViewController ()

@end

@implementation CarStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    if (self.isSeletedMode) {
        [self initBottomView];
    }
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [addButton addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naivHeader addRightButton:addButton];
    
}

- (void)addCard{
    __weak typeof(self) _weakSelf = self;
    
    RIButtonItem *addOliCard = [RIButtonItem itemWithLabel:@"添加油卡" action:^{
        AddCardViewController *addCard = [[AddCardViewController alloc]initWithType:ADD_OIL_CARD];
        [_weakSelf.navigationController pushViewController:addCard animated:YES];
    }];
    
    RIButtonItem *addETCCard = [RIButtonItem itemWithLabel:@"添加ETC卡" action:^{
        AddCardViewController *addCard = [[AddCardViewController alloc]initWithType:ADD_ETC_CARD];
        [_weakSelf.navigationController pushViewController:addCard animated:YES];
    }];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                        message:@"请选择添加卡片类型"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:addOliCard,addETCCard, nil];
    [alertView show];

}

- (UIViewController *)initializeViewControllerAtIndex:(NSInteger)index {
    
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    UIViewController *VC = [[self.viewControllerClasses[index] alloc] init];
    
    if (self.isSeletedMode && [VC isKindOfClass:[OilCardsViewController class]]) {
        [(OilCardsViewController *)VC setIsSeletedMode:YES];
    }
    
    if (self.isSeletedMode && [VC isKindOfClass:[ETCCardsViewController class]]) {
        [(ETCCardsViewController *)VC setIsSeletedMode:YES];
    }
    
    return VC;
}

- (void)initBottomView{
    UIButton * sumbitButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    sumbitButton.backgroundColor = [UIColor buttonGreenColor];
    [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sumbitButton setTitle:@"确认" forState:UIControlStateNormal];
    [sumbitButton addTarget:self action:@selector(assginCarWithCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitButton];
}
- (void)assginCarWithCard{
    
    [self gotoDrvierProgress];
}
- (void)gotoDrvierProgress{
    NSArray *viewControllers;
    NSArray *titles;
    NSString *title;
    viewControllers = @[[DriverUnStartViewController class],[DriverOngoingViewController class],[DriverFinishedViewController class]];
    titles = @[@"待提货",@"运输中",@"已完成"];
    title = @"我的运单";
    DriverProgressViewController *pageVC = [[DriverProgressViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.menuItemWidth = [UIScreen mainScreen].bounds.size.width/titles.count;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    pageVC.menuHeight = 36;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.menuBGColor = [UIColor naviBarColor];
    pageVC.titleColorSelected = [UIColor whiteColor];
    pageVC.titleColorNormal = [UIColor colorWithWhite:1 alpha:0.5];
    pageVC.titleFontName = @"Helvetica-Bold";
    pageVC.titleSizeNormal = 16;
    pageVC.progressHeight = 3;
    pageVC.progressColor = [UIColor whiteColor];
    pageVC.pageAnimatable = YES;
    pageVC.titleSizeSelected = 16;
    pageVC.title = title;
    [self.navigationController pushViewController:pageVC animated:YES];
    
}
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
