//
//  DriverTimeLineViewController.m
//  
//
//  Created by CongCong on 2016/12/3.
//
//

#import "DriverTimeLineViewController.h"
#import "TimeLineCell.h"

@interface DriverTimeLineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, copy) NSString *tenderId;
@property (nonatomic, assign) BOOL isFromTender;
@property (nonatomic, strong) ErrorMaskView *errMaskView;
@end

@implementation DriverTimeLineViewController

- (instancetype)initWithOrderModel:(OrderModel *)model
{
    self = [super init];
    if (self) {
        self.orderModel = model;
    }
    return self;
}

- (instancetype)initWithTenderId:(NSString *)tenderId{
    self = [super init];
    if (self) {
        self.tenderId = tenderId;
        self.isFromTender = YES;
    }
    return self;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self initTableView];
    if (!self.isFromTender) {
        [self addNaviHeaderViewWithTitle:@"时间轴"];
        NSMutableArray *timeLineArray = [NSMutableArray array];
        [timeLineArray addObjectsFromArray:self.orderModel.halfway_events];
        [timeLineArray addObjectsFromArray:self.orderModel.confirm_events];
        [timeLineArray addObjectsFromArray:self.orderModel.pickup_sign_events];
        [timeLineArray addObjectsFromArray:self.orderModel.pickup_events];
        [timeLineArray addObjectsFromArray:self.orderModel.delivery_sign_events];
        [timeLineArray addObjectsFromArray:self.orderModel.delivery_events];
        NSArray *resultArray = [timeLineArray sortedArrayUsingComparator:^NSComparisonResult(EventModel *event1, EventModel *event2) {
            NSComparisonResult result = [event1.time  compare:event2.time];
            return result == NSOrderedDescending; // 升序
        }];
        [self.dataArray addObjectsFromArray:resultArray];
        [self.tableView reloadData];
    }else{
        [self addBlackNaviHaderViewWithTitle:@"时间轴"];
        [self getTimeLine];
    }
    
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    
    [self initErrorMaskView];
}

- (void)initErrorMaskView{
    self.errMaskView = [[ErrorMaskView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    [self.view addSubview:_errMaskView];
    self.errMaskView.messageLabel.text = @"运单暂时没有任何操作";
    self.errMaskView.hidden = YES;
}


- (void)getTimeLine{
    CCWeakSelf(self);
    [SVProgressHUD showWithStatus:@"获取时间轴..."];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.tenderId key:@"tender_id"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GET_ORDER_TIMELINE parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"%@",error.localizedDescription);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", @"无数据"), 200);
            [SVProgressHUD dismiss];
        }else{
            //CCLog(@"---->%@",result);
            NSArray *events = [result objectForKey:@"transport_events"];
            CCLog(@"UnpickOrderCount------------->:%ld",(unsigned long)events.count);
            for (NSDictionary *eventDict in events) {
                EventModel *eventModel = [[EventModel alloc]initWithDictionary:eventDict error:nil];
                [weakself.dataArray insertObject:eventModel atIndex:0];
            }
            [weakself.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
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



- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TimeLineCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (self.dataArray.count==0) {
//        return 0;
//    }
//    return 10;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    CGFloat hight;
//    if (self.dataArray.count==0) {
//        hight =  0;
//    }else{
//        hight = 10;
//    }
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, hight)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.dataArray.count==0) {
//        return 0;
//    }
//    return 10;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGFloat hight;
//    if (self.dataArray.count==0) {
//        hight =  0;
//    }else{
//        hight = 10;
//    }
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, hight)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    return headerView;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventModel *eventModel = [self.dataArray objectAtIndex:indexPath.row];
    if (eventModel.photos.count>0) {
        return 160;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventModel *eventModel = [self.dataArray objectAtIndex:indexPath.row];
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell" forIndexPath:indexPath];
    
    [cell showEventWithModel:eventModel];
    return cell;
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
