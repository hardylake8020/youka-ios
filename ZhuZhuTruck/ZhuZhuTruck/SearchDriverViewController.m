//
//  SearchDriverViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "SearchDriverViewController.h"
#import "DriverCarDetailViewController.h"


@interface SearchDriverViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchDriverViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xcccccc);
    [self initSearchView];
    [self initTableView];
    [self initErrorMaskView];
}

- (void)initSearchView{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTITLEHEIGHT)];
    searchView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:searchView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-60, statusBarHeight(), 60, 44)];
    
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = fontBysize(16);
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor customRedColor] forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancelCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, statusBarHeight(), SYSTEM_WIDTH-60, 44)];
    self.searchBar.placeholder = @"搜索添加";
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"cccccc"];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchBar];
    
}
#pragma  mark 搜索代理


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
        if ([searchBar.text isEmpty]) {
        [self loadNewDataWithSearchKey:@""];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self loadNewDataWithSearchKey:searchBar.text];
}


- (void)loadNewDataWithSearchKey:(NSString *)searchKey{
    
    if ([searchKey isEmpty]) {
        [self.dataArray removeAllObjects];
        self.errMaskView.hidden = NO;
        return;
    }
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:searchKey key:@"keyword"];
    [SVProgressHUD showWithStatus:@"搜索中"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_SEARCH_DRIVERS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
        }else{
            
            [weakself.dataArray removeAllObjects];
            NSArray *trucks = [result objectForKey:@"drivers"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)trucks.count);
            for (NSDictionary *truckDict in trucks) {
                DriverModel *model = [[DriverModel alloc]initWithDictionary:truckDict error:nil];
                [weakself.dataArray addObject:model];
            }
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"搜索到%ld个司机",weakself.dataArray.count]];
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

- (void)cancelCall{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DriverModel *driverModel = [self.dataArray objectAtIndex:indexPath.section];
    DrvierCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrvierCarCell" forIndexPath:indexPath];
    [cell showDriverCellWithDriverModel:driverModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DriverModel *driverModel = [self.dataArray objectAtIndex:indexPath.section];
    CCWeakSelf(self);
    DriverCarDetailViewController *drvier = [[DriverCarDetailViewController alloc]initWithDriverModel:driverModel andSucceedCallBack:^{
        [weakself.dataArray removeObject:driverModel];
        [weakself.tableView reloadData];
    }];
    [self.navigationController pushViewController:drvier animated:YES];
}


- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DrvierCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DrvierCarCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 10)];
    [self.tableView setSeparatorColor:[UIColor customGrayColor]];
    [self.view addSubview:self.tableView];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"请输入关键字搜索";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.searchBar.text isEmpty]) {
        [self.searchBar becomeFirstResponder];
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
