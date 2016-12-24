//
//  HomePageViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "HomePageViewController.h"
#import "QnUploadManager.h"
#import "SettingViewController.h"
#import "SettingViewController.h"
#import "CarStockViewController.h"
#import "OilCardsViewController.h"
#import "ETCCardsViewController.h"
#import "MyWalletViewController.h"
#import "MyDriversViewController.h"
#import "DriverUnStartViewController.h"
#import "DriverOngoingViewController.h"
#import "DriverFinishedViewController.h"
#import "DriverProgressViewController.h"
#import "MediatorPendingViewController.h"
#import "MediatorProgressViewController.h"
#import "MediatorFinishedViewController.h"
#import "MediatorFindOrdersViewController.h"
#import "MediatorOrderDetailViewController.h"
#import "MediatorTransportingViewController.h"

@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UILabel *mediatorNumberLabel;
    UILabel *driverNumberLabel;
    
    int _limit;//条数限制
    int _skipCount;//跳 过 几条
    int _totoalCount;// 总数
    int _currentPage;// 当前页
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 10;
    _currentPage = 0;
    _skipCount = 0;
    _totoalCount = 0;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    LocationTracker *tracker = [LocationTracker defaultLoactionTarker];
    [AddressManager sharedManager];
    [[QnUploadManager sharedManager] getToken];
    [tracker startLocationTracking];
    [self addBlackNaviHaderViewWithTitle:@"柱柱优卡"];
    [self initHeaderViewButton];
    [self initTableView];
    [self initErrorMaskView];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现订单";
    self.errMaskView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    driverNumberLabel.text = [[DBManager sharedManager] readAllOngoingOrderCount];
    _currentPage = 0;
    [self loadNewData];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)initHeaderViewButton{
    
    
//    UIButton *headerButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-15-26-6, 26+3, 24, 24)];
//    headerButton.clipsToBounds = YES;
//    headerButton.layer.cornerRadius = 12;
//    [headerButton setBackgroundImage:[UIImage imageNamed:@"ic_setting"] forState:UIControlStateNormal];
//    [headerButton addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:headerButton];
    
    
    UIView* roundView = [[UIView alloc]initWithFrame:CGRectMake(14, 27, 32, 32)];
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.clipsToBounds = YES;
    roundView.layer.cornerRadius = 16;
    [self.view addSubview:roundView];
    UIButton * headButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 28, 30, 30)];
    [headButton setBackgroundImage:[UIImage imageNamed:@"headerImage"] forState:UIControlStateNormal];
    headButton.clipsToBounds      = YES;
    headButton.layer.cornerRadius = 15;
    [headButton addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headButton];

    
    
    
    
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 100)];
    progressView.backgroundColor = [UIColor naviBlackColor];
    [self.view addSubview:progressView];
    
    
    UIButton *mediatorButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/2, 100)];
    [mediatorButton addTarget:self action:@selector(gotoMediatorProgress) forControlEvents:UIControlEventTouchUpInside];
    [progressView addSubview:mediatorButton];
    
    mediatorNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/2, 60)];
    mediatorNumberLabel.text = @"4";
    mediatorNumberLabel.textAlignment = NSTextAlignmentCenter;
    mediatorNumberLabel.font = [UIFont boldSystemFontOfSize:32];
    mediatorNumberLabel.textColor = [UIColor whiteColor];
    [mediatorButton addSubview:mediatorNumberLabel];
    
    UILabel *mediatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH/2, 40)];
    mediatorLabel.text = @"比价、抢单中";
    mediatorLabel.textAlignment = NSTextAlignmentCenter;
    mediatorLabel.textColor = [UIColor whiteColor];
    [mediatorButton addSubview:mediatorLabel];
    
    UIButton *driverButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/2, 0, SYSTEM_WIDTH/2, 100)];
    [driverButton addTarget:self action:@selector(gotoDrvierProgress) forControlEvents:UIControlEventTouchUpInside];
    [progressView addSubview:driverButton];
    
    driverNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/2, 60)];
    
    driverNumberLabel.textAlignment = NSTextAlignmentCenter;
    driverNumberLabel.font = [UIFont boldSystemFontOfSize:32];
    driverNumberLabel.textColor = [UIColor whiteColor];
    [driverButton addSubview:driverNumberLabel];
    
    UILabel *driverLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH/2, 40)];
    driverLabel.text = @"待处理运单";
    driverLabel.textAlignment = NSTextAlignmentCenter;
    driverLabel.textColor = [UIColor whiteColor];
    [driverButton addSubview:driverLabel];
    
    UIView *buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+100, SYSTEM_WIDTH, 110)];
    buttonsView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    NSArray *images = @[@"find_tender",@"assign_car",@"wallet",@"oil_card"];
    NSArray *titles = @[@"我要找货",@"我的车队",@"我的钱包",@"我的卡劵"];
    for (int i=0; i<titles.count; i++) {
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/4*i, 0, SYSTEM_WIDTH/4+1, 100)];
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.layer.borderColor = [UIColor customGrayColor].CGColor;
        itemButton.layer.borderWidth = 1;
        itemButton.tag = 1000+i;
        [buttonsView addSubview:itemButton];
        itemButton.backgroundColor = [UIColor whiteColor];
        UIImage *iconImage = [UIImage imageNamed:[images objectAtIndex:i]];
        UIImageView *itemImage = [[UIImageView alloc]initWithImage:iconImage];
        [itemButton addSubview:itemImage];
        
        itemImage.sd_layout
        .widthIs(40)
        .autoHeightRatio((float)iconImage.size.height/(float)iconImage.size.width)
        .centerXEqualToView(itemButton)
        .centerYIs(40);
        
        
        UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH/4, 40)];
        itemLabel.font = [UIFont systemFontOfSize:12];
        itemLabel.text = [titles objectAtIndex:i];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [itemButton addSubview:itemLabel];
        
    }
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 109.5, SYSTEM_WIDTH, 0.5)];
//    lineView.backgroundColor = [UIColor customGrayColor];
//    [buttonsView addSubview:lineView];

    [self.view addSubview:buttonsView];
}


- (void)initTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+210, SYSTEM_WIDTH, SYSTEM_HEIGHT-210-SYSTITLEHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 1)];
    
    [self.view addSubview:self.tableView];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [weakself loadNewData];
    }];
    
//    [self tableHeaderRefesh];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
//    [self tableHeaderRefesh];
}

- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    
    _currentPage++;
    if (_currentPage==1) {
        _skipCount = 0;
    }else{
        _skipCount = (int)self.dataArray.count;
    }
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters putInt:_currentPage key:@"current_page"];
    [parameters putInt:_limit key:@"limit"];
    [parameters putInt:_skipCount key:@"skip_count"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:GET_UNSTART_TENDER parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        NSInteger count = 10;
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            NSArray *orders = [result objectForKey:@"tenders"];
            
            if (_currentPage==1) {
                //刷新
                [weakself.dataArray removeAllObjects];
            }
            CCLog(@"UnpickOrderCount------------->:%ld",orders.count);
            count = orders.count;
            for (NSDictionary *orderDict in orders) {
                TenderModel *tenderModel = [[TenderModel alloc]initWithDictionary:orderDict error:nil];
                [weakself.dataArray addObject:tenderModel];
            }
            [weakself.tableView reloadData];
            
        }
        if (weakself.dataArray.count==0) {
            weakself.errMaskView.hidden = NO;
        }else{
            weakself.errMaskView.hidden = YES;
        }
        [weakself.tableView.mj_header endRefreshing];
        if (count<10) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
    }];
    
}

#pragma mark ---> UITableViewDelegate dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.row];
    TenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderCell" forIndexPath:indexPath];
    [cell showTenderCellWithTenderModel:tenderModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   TenderModel *tenderModel = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([tenderModel.tender_type isEqualToString:@"grab"]) {
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:RobTenderUnStart andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderUnStart andTenderModel:tenderModel];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

- (void)itemButtonClick:(UIButton *)button{
    NSInteger tag = button.tag-1000;
    switch (tag) {
        case 0:
            [self gotoSearchOrders];
            break;
        case 1:
            [self gotoMyDrivers];
            break;
        case 2:
            [self gotoMyWallet];
            break;
        case 3:
            [self gotoMyOilCardsStock];
            break;
        default:
            break;
    }
}
- (void)gotoSetting{
    SettingViewController *setting  = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)gotoMyDrivers{
    MyDriversViewController *myDrivers  = [[MyDriversViewController alloc]init];
    [self.navigationController pushViewController:myDrivers animated:YES];
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
- (void)gotoMediatorProgress{
    NSArray *viewControllers;
    NSArray *titles;
    NSString *title;
    viewControllers = @[[MediatorPendingViewController class],[MediatorTransportingViewController class],[MediatorFinishedViewController class]];
    titles = @[@"待处理",@"运输中",@"已完成"];
    title = @"我的定单";
    MediatorProgressViewController *pageVC = [[MediatorProgressViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
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
- (void)gotoMyWallet{
    MyWalletViewController *myWallet  = [[MyWalletViewController alloc]init];
    [self.navigationController pushViewController:myWallet animated:YES];
}
- (void)gotoMyOilCardsStock{
//    NSArray *viewControllers;
//    NSArray *titles;
//    NSString *title;
//    viewControllers = @[[OilCardsViewController class],[ETCCardsViewController class]];
//    titles = @[@"油卡",@"ETC卡"];
//    title = @"我的卡劵";
//    CarStockViewController *pageVC = [[CarStockViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
//    pageVC.menuItemWidth = [UIScreen mainScreen].bounds.size.width/titles.count;
//    pageVC.postNotification = YES;
//    pageVC.bounces = YES;
//    pageVC.menuHeight = 36;
//    pageVC.menuViewStyle = WMMenuViewStyleLine;
//    pageVC.menuBGColor = [UIColor naviBlackColor];
//    pageVC.titleColorSelected = [UIColor whiteColor];
//    pageVC.titleColorNormal = [UIColor colorWithWhite:0.9 alpha:0.8];
//    pageVC.titleFontName = @"Helvetica-Bold";
//    pageVC.titleSizeNormal = 18;
//    pageVC.progressHeight = 4;
//    pageVC.progressColor = [UIColor whiteColor];
//    pageVC.pageAnimatable = YES;
//    pageVC.titleSizeSelected = 18;
//    pageVC.title = title;
//    [self.navigationController pushViewController:pageVC animated:YES];
    
    OilCardsViewController *card = [[OilCardsViewController alloc]init];
    [self.navigationController pushViewController:card animated:YES];

}
- (void)gotoSearchOrders{
    MediatorFindOrdersViewController *findOrders  = [[MediatorFindOrdersViewController alloc]init];
    [self.navigationController pushViewController:findOrders animated:YES];
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
