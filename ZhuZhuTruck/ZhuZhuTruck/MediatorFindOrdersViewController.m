//
//  MediatorFindOrdersViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorFindOrdersViewController.h"

#import "MediatorOrderDetailViewController.h"
@interface MediatorFindOrdersViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{

    UIButton * _totoalButton;
    UIButton * _bidButton;
    UIButton * _robButton;
    
    CCTextFiled *_fromAddressTextFiled;
    CCTextFiled *_toAddressTextFiled;
    
    NSString *_formSearchKey;
    NSString *_toSearchKey;
    NSString *_tendType;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@property (nonatomic, assign) int limit;//条数限制
@property (nonatomic, assign) int skipCount;//跳 过 几条
@property (nonatomic, assign) int totoalCount;// 总数
@property (nonatomic, assign) int currentPage;// 当前页
@end

@implementation MediatorFindOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tendType = @"";
    _formSearchKey = @"";
    _toSearchKey = @"";
    _limit = 10;
    _currentPage = 0;
    _skipCount = 0;
    _totoalCount = 0;
    [self addBlackNaviHaderViewWithTitle:@"柱柱货源"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderViewButton];
    [self initTableView];
    [self initErrorMaskView];
}
- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现货源";
    self.errMaskView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentPage = 0;
    [self tableHeaderRefesh];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initHeaderViewButton{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 110)];
    [self.view addSubview:headerView];
    
    UIButton * searchButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search_tender"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(serchClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    searchButton.sd_layout
    .rightSpaceToView(headerView,30)
    .topSpaceToView(headerView,15)
    .heightIs(29)
    .widthIs(29);

    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH-80, 70)];
    [headerView addSubview:addressView];
    
    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.text = @"至";
    centerLabel.textAlignment = NSTextAlignmentRight;
    
    centerLabel.textColor = [UIColor darkGrayColor];
    centerLabel.font = fontBysize(12);
    [addressView addSubview:centerLabel];
    
    centerLabel.sd_layout
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .centerXEqualToView(addressView)
    .widthIs(24);
    
    _fromAddressTextFiled = [[CCTextFiled alloc]init];
    _fromAddressTextFiled.textAlignment = NSTextAlignmentCenter;
    _fromAddressTextFiled.font = fontBysize(16);
    _fromAddressTextFiled.placeholder = @"请输入起始地";
    _fromAddressTextFiled.delegate = self;
    _fromAddressTextFiled.layer.borderWidth = 0;
    [addressView addSubview:_fromAddressTextFiled];
    _fromAddressTextFiled.sd_layout
    
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .leftSpaceToView (addressView,15)
    .rightSpaceToView(centerLabel,0);
    
    _toAddressTextFiled = [[CCTextFiled alloc]init];
    _toAddressTextFiled.textAlignment = NSTextAlignmentCenter;
    _toAddressTextFiled.font = fontBysize(16);
    _toAddressTextFiled.placeholder = @"请输入目的地";
    _toAddressTextFiled.delegate = self;
    _toAddressTextFiled.layer.borderWidth = 0;
    [addressView addSubview:_toAddressTextFiled];
    
    _toAddressTextFiled.sd_layout
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .rightSpaceToView (addressView,15)
    .leftSpaceToView(centerLabel,0);
    
    UIView *seletedBar = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SYSTEM_WIDTH, 40)];
    [headerView addSubview:seletedBar];
    
    _totoalButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/3, 40)];
    [_totoalButton setTitle:@"全部" forState:UIControlStateNormal];
    [_totoalButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_totoalButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _totoalButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [seletedBar addSubview:_totoalButton];
    [_totoalButton addTarget:self action:@selector(totalClick) forControlEvents:UIControlEventTouchDown];
    _totoalButton.selected = YES;
    
    _bidButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3, 0, SYSTEM_WIDTH/3, 40)];;
    [_bidButton setTitle:@"比价" forState:UIControlStateNormal];
    [_bidButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_bidButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _bidButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [seletedBar addSubview:_bidButton];
    [_bidButton addTarget:self action:@selector(bidClick) forControlEvents:UIControlEventTouchDown];

    
    _robButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3*2, 0, SYSTEM_WIDTH/3, 40)];;
    [_robButton setTitle:@"抢单" forState:UIControlStateNormal];
    [_robButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_robButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _robButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [seletedBar addSubview:_robButton];
    [_robButton addTarget:self action:@selector(robClick) forControlEvents:UIControlEventTouchDown];

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:lineView];
    
    lineView.sd_layout
    .leftEqualToView (headerView)
    .rightEqualToView(headerView)
    .topSpaceToView(addressView,0)
    .heightIs(0.5);
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:bottomLine];
    
    
    bottomLine.sd_layout
    .leftEqualToView (headerView)
    .rightEqualToView(headerView)
    .bottomEqualToView(headerView)
    .heightIs(0.5);
    
}

- (void)totalClick{
    if (_totoalButton.selected) {
        return;
    }
    _tendType = @"";
    _totoalButton.selected = YES;
    _bidButton.selected = NO;
    _robButton.selected = NO;
    [SVProgressHUD show];
    _formSearchKey = @"";
    _toSearchKey = @"";
    _currentPage = 0;
    [self loadNewData];
}

- (void)bidClick{
    if (_bidButton.selected) {
        return;
    }
    _tendType = @"compare";
    _bidButton.selected = YES;
    _totoalButton.selected = NO;
    _robButton.selected = NO;
    [SVProgressHUD show];
    _formSearchKey = @"";
    _toSearchKey = @"";
    _currentPage = 0;
    [self loadNewData];
}

- (void)robClick{
    if (_robButton.selected) {
        return;
    }
    
    _tendType = @"grab";
    _robButton.selected = YES;
    _bidButton.selected = NO;
    _totoalButton.selected = NO;
    [SVProgressHUD show];
    _formSearchKey = @"";
    _toSearchKey = @"";
    _currentPage = 0;
    [self loadNewData];
}

- (void)serchClick{
//    if ([_fromAddressTextFiled.text isEmpty]&&[_toAddressTextFiled.text isEmpty]) {
//        toast_showInfoMsg(@"请至少输入一个地址", 200);
//        return;
//    }
    _formSearchKey = _fromAddressTextFiled.text;
    _toSearchKey = _toAddressTextFiled.text;
    [SVProgressHUD show];
    _currentPage = 0;
    [self loadNewData];
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+110, SYSTEM_WIDTH, SYSTEM_HEIGHT-110-SYSTITLEHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];

    self.tableView.tableHeaderView = [self tabHeaderView];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    
    [self.view addSubview:self.tableView];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.currentPage = 0;
        [weakself loadNewData];
    }];
    
    //    [self tableHeaderRefesh];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
}

- (UIView *)tabHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    return headerView;
}
- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    [self.view endEditing:YES];
    _currentPage++;
    if (_currentPage==1) {
        _skipCount = 0;
    }else{
        _skipCount = (int)self.dataArray.count;
    }

    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:_tendType key:@"tender_type"];
    [parameters put:_formSearchKey key:@"pickup_address"];
    [parameters put:_toSearchKey key:@"delivery_address"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:GET_UNSTART_TENDER parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            //CCLog(@"---->%@",result);
            if (weakself.currentPage==1) {
                //刷新
                [weakself.dataArray removeAllObjects];
            }
            NSArray *orders = [result objectForKey:@"tenders"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)orders.count);
            weakself.totoalCount = [result intForKey:@"totalCount"];
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
        if (self.dataArray.count >= weakself.totoalCount) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD dismiss];
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
    return 130;
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
    }else if([tenderModel.tender_type isEqualToString:@"compare"]){
        
        if ([tenderModel isAlreadyBind]) {
            MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderOngoing andTenderModel:tenderModel];
            [self.navigationController pushViewController:orderDetail animated:YES];
        }else{
            MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:BidTenderUnStart andTenderModel:tenderModel];
            [self.navigationController pushViewController:orderDetail animated:YES];
        }
    }else if([tenderModel.tender_type isEqualToString:@"compares_ton"]){
        if ([tenderModel isAlreadyBind]) {
            MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:TonTenderOngoing andTenderModel:tenderModel];
            [self.navigationController pushViewController:orderDetail animated:YES];
        }else{
            MediatorOrderDetailViewController *orderDetail = [[MediatorOrderDetailViewController alloc]initWithTenderStatus:TonTenderUnStart andTenderModel:tenderModel];
            [self.navigationController pushViewController:orderDetail animated:YES];
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
