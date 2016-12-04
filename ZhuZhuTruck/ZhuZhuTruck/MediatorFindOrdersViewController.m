//
//  MediatorFindOrdersViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorFindOrdersViewController.h"

@interface MediatorFindOrdersViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{

    UIButton * _totoalButton;
    UIButton * _bidButton;
    UIButton * _robButton;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MediatorFindOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviHeaderViewWithTitle:@"货源列表"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderViewButton];
    [self initTableView];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initHeaderViewButton{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_TITLE_HEIGHT, SYSTEM_WIDTH, 110)];
    [self.view addSubview:headerView];
    
    UIImageView * searchImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    [headerView addSubview:searchImage];
    searchImage.sd_layout
    .rightSpaceToView(headerView,19)
    .topSpaceToView(headerView,19)
    .heightIs(22)
    .widthIs(22);
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH-60, 60)];
    [headerView addSubview:addressView];
    
    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.text = @"至";
    centerLabel.textColor = [UIColor darkGrayColor];
    centerLabel.font = fontBysize(12);
    [addressView addSubview:centerLabel];
    
    centerLabel.sd_layout
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .centerXEqualToView(addressView)
    .widthIs(20);
    
    UILabel *fromAddressLabel = [[UILabel alloc]init];
    fromAddressLabel.textAlignment = NSTextAlignmentCenter;
    fromAddressLabel.font = fontBysize(18);
    [addressView addSubview:fromAddressLabel];
    
    fromAddressLabel.text = @"上海上海";
    
    fromAddressLabel.sd_layout
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .leftEqualToView (addressView)
    .rightSpaceToView(centerLabel,0);
    
    CCTextFiled *toAddressTextFiled = [[CCTextFiled alloc]init];
    toAddressTextFiled.textAlignment = NSTextAlignmentCenter;
    toAddressTextFiled.font = fontBysize(18);
    toAddressTextFiled.placeholder = @"目的地";
    toAddressTextFiled.delegate = self;
    toAddressTextFiled.layer.borderWidth = 0;
    [addressView addSubview:toAddressTextFiled];
    
    toAddressTextFiled.sd_layout
    .topEqualToView(addressView)
    .bottomEqualToView(addressView)
    .rightEqualToView (addressView)
    .leftSpaceToView(centerLabel,0);
    
    UIView *seletedBar = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH, 50)];
    [headerView addSubview:seletedBar];
    
    _totoalButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/3, 50)];
    [_totoalButton setTitle:@"全部" forState:UIControlStateNormal];
    [_totoalButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_totoalButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _totoalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [seletedBar addSubview:_totoalButton];
    [_totoalButton addTarget:self action:@selector(totalClick) forControlEvents:UIControlEventTouchDown];
    _totoalButton.selected = YES;
    
    _bidButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3, 0, SYSTEM_WIDTH/3, 50)];;
    [_bidButton setTitle:@"竞价" forState:UIControlStateNormal];
    [_bidButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_bidButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _bidButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [seletedBar addSubview:_bidButton];
    [_bidButton addTarget:self action:@selector(bidClick) forControlEvents:UIControlEventTouchDown];

    
    _robButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3*2, 0, SYSTEM_WIDTH/3, 50)];;
    [_robButton setTitle:@"抢单" forState:UIControlStateNormal];
    [_robButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [_robButton setTitleColor:[UIColor customRedColor] forState:UIControlStateSelected];
    _robButton.titleLabel.font = [UIFont systemFontOfSize:16];
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
    _totoalButton.selected = YES;
    _bidButton.selected = NO;
    _robButton.selected = NO;
}

- (void)bidClick{
    if (_bidButton.selected) {
        return;
    }
    _bidButton.selected = YES;
    _totoalButton.selected = NO;
    _robButton.selected = NO;
}

- (void)robClick{
    if (_robButton.selected) {
        return;
    }
    _robButton.selected = YES;
    _bidButton.selected = NO;
    _totoalButton.selected = NO;
}


- (void)initTableView{
    
    [self.dataArray addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTEM_TITLE_HEIGHT+110, SYSTEM_WIDTH, SYSTEM_HEIGHT-110-SYSTEM_TITLE_HEIGHT)];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];

    self.tableView.tableHeaderView = [self tabHeaderView];
    
    [self.view addSubview:self.tableView];
    
    CCWeakSelf(self);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
    //    [self tableHeaderRefesh];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        });
    }];
}
- (UIView *)tabHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor customGrayColor];
    [headerView addSubview:bottomLine];
    bottomLine.sd_layout
    .leftEqualToView (headerView)
    .rightEqualToView(headerView)
    .bottomEqualToView(headerView)
    .heightIs(0.5);
    
    return headerView;
}
- (void)tableHeaderRefesh{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData{
    
}

//- (void)initErrorMaskView{
//    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
//    [self.tableView addSubview:_errMaskView];
//    self.errMaskView.messageLabel.text = @"暂时未发现未开始的运单";
//    self.errMaskView.hidden = YES;
//}

#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderCell" forIndexPath:indexPath];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
