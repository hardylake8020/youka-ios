//
//  ETCCardsViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ETCCardsViewController.h"
#import "DriverCarDetailViewController.h"
@interface ETCCardsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation ETCCardsViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"ETC卡";
    [self initTableView];
    [self initErrorMaskView];
}


- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"暂时未发现ETC卡";
    self.errMaskView.hidden = YES;
}

- (void)initTableView{
    
    if (self.isSeletedMode) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100-60)];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-100)];
    }
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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
    
    [self tableHeaderRefesh];
    
}

- (void)loadNewData{
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GET_CARD_LIST parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
        }else{
            //CCLog(@"---->%@",result);
            [weakself.dataArray removeAllObjects];
            NSArray *cards = [result objectForKey:@"cards"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)cards.count);
            for (NSDictionary *cardDict in cards) {
                //                CCLog(@"%@",orderDict);
                CardModel *cardModel = [[CardModel alloc]initWithDictionary:cardDict error:nil];
                
                if ([cardModel.type isEqualToString:@"etc"]) {
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
    ETCCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ETCCardCell" forIndexPath:indexPath];
    
    if (!self.isSeletedMode) {
        [cell showCardCellWithModel:cardModel];
    }else{
        [cell showSeletedCardCellWithModel:cardModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardModel *cardModel = [self.dataArray objectAtIndex:indexPath.section];
    if (self.isSeletedMode) {
        cardModel.isSeleted = [NSNumber numberWithBool:!cardModel.isSeleted.boolValue];
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:cardModel];
        [tableView reloadData];
        
    }else{
        if (![cardModel.truck_number isEmpty]) {
            DriverCarDetailViewController *carDetail = [[DriverCarDetailViewController alloc]init];
            [self.navigationController pushViewController:carDetail animated:YES];
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
