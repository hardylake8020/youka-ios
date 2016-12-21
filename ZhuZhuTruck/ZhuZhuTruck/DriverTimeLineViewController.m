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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviHeaderViewWithTitle:@"时间轴"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTableView];

}
- (void)initTableView{
    
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TimeLineCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 20)];
    [self.view addSubview:self.tableView];

}
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
