//
//  OilCardsViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "OilCardsViewController.h"
#import "CardModel.h"
#import "AddCardViewController.h"
#import "HomePageViewController.h"
#import "DriverUnStartViewController.h"
#import "DriverOngoingViewController.h"
#import "DriverFinishedViewController.h"
#import "DriverProgressViewController.h"
#import "DriverCarDetailViewController.h"
@interface OilCardsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CardModel *seletedCard;
@property (nonatomic, strong) TenderModel *tenderModel;
@property (nonatomic, strong) TruckModel *truckModel;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation OilCardsViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithTenderModel:(TenderModel *)tenderModel andTruckModel:(TruckModel *)truckModel
{
    self = [super init];
    if (self) {
        self.isSeletedMode = YES;
        self.tenderModel = tenderModel;
        self.truckModel = truckModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.fd_prefersNavigationBarHidden = YES;
    
    if (self.isSeletedMode) {
        self.title = @"选择卡劵";
        self.fd_interactivePopDisabled = YES;
    }else{
        self.title = @"我的卡劵";
    }

    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    if (self.isSeletedMode) {
        [self initBottomView];
    }
    
    if (!self.isSeletedMode) {
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [addButton addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [naivHeader addRightButton:addButton];
    }
    [self initTableView];
    [self initErrorMaskView];
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    if (self.isSeletedMode) {
        self.errMaskView.messageLabel.text = @"暂时未发现未绑定的卡劵";
    }else{
        self.errMaskView.messageLabel.text = @"暂时未发现卡劵";
    }
    
    self.errMaskView.hidden = YES;
}

- (void)initTableView{
    
    if (self.isSeletedMode) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-60)];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    }
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OilCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OilCardCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ETCCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ETCCardCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
//    [self tableHeaderRefesh];
}

- (void)loadNewData{
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GET_CARD_LIST parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            [weakself.dataArray removeAllObjects];
            NSArray *cards = [result objectForKey:@"cards"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)cards.count);
            for (NSDictionary *cardDict in cards) {
                CardModel *cardModel = [[CardModel alloc]initWithDictionary:cardDict error:nil];
                if (weakself.isSeletedMode) {
                    if ([cardModel.truck_number isEmpty]) {
                        [weakself.dataArray addObject:cardModel];
                    }
                }else{
                    [weakself.dataArray addObject:cardModel];
                }
            }
            [weakself.tableView reloadData];
        }
        if (weakself.dataArray.count==0) {
            weakself.errMaskView.hidden = NO;
        }else{
            weakself.errMaskView.hidden = YES;
        }
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}


- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
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
    
    
    
    CardModel *cardModel = [self.dataArray objectAtIndex:indexPath.section];
    
    if ([cardModel.type isEqualToString:@"etc"]) {
        ETCCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ETCCardCell" forIndexPath:indexPath];
        if (!self.isSeletedMode) {
            [cell showCardCellWithModel:cardModel];
            
        }else{
            [cell showSeletedCardCellWithModel:cardModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        OilCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OilCardCell" forIndexPath:indexPath];
        if (!self.isSeletedMode) {
            [cell  showCardCellWithModel:cardModel];
        }else{
            [cell showSeletedCardCellWithModel:cardModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.seletedCard) {
        self.seletedCard.isSeleted = @NO;
    }
    
    CardModel *cardModel = [self.dataArray objectAtIndex:indexPath.section];
    if (self.isSeletedMode) {
        cardModel.isSeleted = @YES;
        self.seletedCard = cardModel;
        [tableView reloadData];
        
    }else{
        if (![cardModel.truck_number isEmpty]) {
            DriverCarDetailViewController *carDetail = [[DriverCarDetailViewController alloc]initWithTruckModel:cardModel.truck];
            [self.navigationController pushViewController:carDetail animated:YES];
        }
    }
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
    
    if (!self.seletedCard) {
        toast_showInfoMsg(@"请选择一张卡劵", 200);
        return;
    }
    
    NSString *titleString;
    if ([self.seletedCard.type isEqualToString:@"etc"]) {
        titleString = [NSString stringWithFormat:@"ETC卡%@,请确认分配信息是否正确。",self.seletedCard.number];
    }else{
        titleString = [NSString stringWithFormat:@"油卡%@,请确认分配信息是否正确。",self.seletedCard.number];
    }
    
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *seletdCarItem = [RIButtonItem itemWithLabel:@"确认" action:^{
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters put:accessToken() key:ACCESS_TOKEN];
        [parameters put:self.tenderModel._id key:@"tender_id"];
        [parameters put:self.truckModel._id key:@"truck_id"];
        [parameters put:self.seletedCard._id key:@"card_id"];
        [SVProgressHUD showWithStatus:@"正在分配..."];
        [[HttpRequstManager requestManager] postWithRequestBodyString:USER_ASSGIN_ORDER_TO_TRUCK parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"分配失败")];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"分配成功"];
                [_weakSelf jumpToHomePage];
            }
        }];

    }];
    
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.truckModel.truck_number
                                                        message:titleString
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:seletdCarItem, nil];
    [alertView show];
}

- (void)jumpToHomePage{
    for (NSInteger i=self.navigationController.viewControllers.count-1; i>=0; i--) {
        UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:i];
        if ([VC isKindOfClass:[HomePageViewController class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
        }
    }

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
