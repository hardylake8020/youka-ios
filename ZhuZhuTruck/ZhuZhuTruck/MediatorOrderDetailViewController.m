//
//  MediatorOrderDetailViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MediatorOrderDetailViewController.h"
#import "TenderDetailCell.h"
#import "TenderDetailHeaderCell.h"
#import "MyDriversViewController.h"
#import "DriversMapViewController.h"
#import "TenderDetailTableDataModel.h"
#import "MediatorPendingViewController.h"
#import "MediatorProgressViewController.h"
#import "MediatorFinishedViewController.h"
#import "MediatorTransportingViewController.h"
@interface MediatorOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    CGFloat _headerHight;
    CGFloat _bottomHight;
    UIView *_operationView;
    UIView *_headerView;
    CCTextFiled *_priceTextField;
    CCTextFiled *_unitTextField;
    UILabel * _timeLeftLabel;
}
@property (nonatomic, assign) TenderOrderStatus tenderStatus;
@property (nonatomic, strong) TenderDetailTableDataModel *tableModel;
@property (nonatomic, strong) TenderModel *tenderModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger   timeLeft;
@property (nonatomic, strong) NSTimer     *runTimer;
@end

@implementation MediatorOrderDetailViewController

- (instancetype)initWithTenderStatus:(TenderOrderStatus)status
{
    self = [super init];
    if (self) {
        self.tenderStatus = status;
    }
    return self;
}
- (instancetype)initWithTenderStatus:(TenderOrderStatus)status andTenderModel:(TenderModel *)model
{
    self = [super init];
    if (self) {
        self.tenderStatus = status;
        self.tenderModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.tenderStatus) {
        case BidTenderUnStart:
        case BidTenderOngoing:
        case BidTenderSucceed:
        case BidTenderFailed:
        case TonTenderUnStart:
        case TonTenderOngoing:
        case TonTenderSucceed:
        case TonTenderFailed:{
            [self addBlackNaviHaderViewWithTitle:@"比价详情"];
        }
            break;
        case RobTenderUnStart:
        case RobTenderSucceed:{
            [self addBlackNaviHaderViewWithTitle:@"抢单详情"];
        }
            break;
    }
    UIButton *mapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [mapButton addTarget:self action:@selector(showMapDetails) forControlEvents:UIControlEventTouchUpInside];
    [mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.naviHeaderView addRightButton:mapButton];
    

    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderView];
    [self initSumbitView];
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)showMapDetails{
    if (!self.tenderModel.pickup_region_location.count||!self.tenderModel.delivery_region_location) {
        toast_showInfoMsg(@"地址位置不完整", 200);
        return;
    }
    DriversMapViewController *map = [[DriversMapViewController alloc]initWithTenderModel:self.tenderModel];
    [self.navigationController pushViewController:map animated:YES];
}

- (void)initHeaderView{

    if (_headerView) {
        [_headerView removeFromSuperview];
    }
    
    switch (self.tenderStatus) {
        case BidTenderUnStart:
        case BidTenderOngoing:
        {
            _headerHight = 100;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, _headerHight)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价剩余时间";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            _timeLeftLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            _timeLeftLabel.textColor = [UIColor customRedColor];
            _timeLeftLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:_timeLeftLabel];
            [self timeClockRun];
            self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeClockRun) userInfo:nil repeats:YES];
            
            _timeLeftLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"出价不得高于";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元",self.tenderModel.highest_protect_price];
            heighPriceLabel.textColor = [UIColor customRedColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
            
        }
            break;
        case BidTenderSucceed:
        {
            _headerHight = 100;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 100)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价结果";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            statusLabel.textColor = [UIColor customGreenColor];
            statusLabel.font = [UIFont boldSystemFontOfSize:16];
            statusLabel.text = @"恭喜你中标了";
            [_headerView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"中标情况";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元",self.tenderModel.winner_price];
            heighPriceLabel.textColor = [UIColor customGreenColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
        }
            break;

  
        case BidTenderFailed:

        {
            _headerHight = 100;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 100)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价结果";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            statusLabel.textColor = [UIColor customRedColor];
            statusLabel.font = [UIFont boldSystemFontOfSize:16];
            statusLabel.text = @"很遗憾你未中标";
            [_headerView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"中标情况";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元 （%@）",self.tenderModel.winner_price, [self.tenderModel.driver_winner.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
            
            heighPriceLabel.textColor = [UIColor customRedColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
        }
            break;

        case RobTenderUnStart:

        case RobTenderSucceed:

        {
            _headerHight = 0;
        }
            break;
        case TonTenderUnStart:
        case TonTenderOngoing:
        {
            _headerHight = 150;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, _headerHight)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价剩余时间";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            _timeLeftLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            _timeLeftLabel.textColor = [UIColor customRedColor];
            _timeLeftLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:_timeLeftLabel];
            [self timeClockRun];
            self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeClockRun) userInfo:nil repeats:YES];
            
            _timeLeftLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *unitLabel = [[UILabel alloc]init];
            unitLabel.text = @"保底吨数";
            unitLabel.textColor = [UIColor grayTextColor];
            unitLabel.font = fontBysize(14);
            [_headerView addSubview:unitLabel];
            
            unitLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *unitCountLabel = [[UILabel alloc]init];
            unitCountLabel.text = [NSString stringWithFormat:@"%@ 吨",self.tenderModel.lowest_tons_count];
            unitCountLabel.textColor = [UIColor customRedColor];
            unitCountLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:unitCountLabel];
            
            unitCountLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(unitLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"保底价不高于";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .topSpaceToView(_headerView,100)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元",self.tenderModel.highest_protect_price];
            heighPriceLabel.textColor = [UIColor customRedColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .topSpaceToView(_headerView,100)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
            UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, SYSTEM_WIDTH, 0.5)];
            lineView3.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView3];
            
        }
            break;
        case TonTenderSucceed:
        {
            _headerHight = 150;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, _headerHight)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价结果";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *unitLabel = [[UILabel alloc]init];
            unitLabel.text = @"保底吨数";
            unitLabel.textColor = [UIColor grayTextColor];
            unitLabel.font = fontBysize(14);
            [_headerView addSubview:unitLabel];
            
            unitLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *unitCountLabel = [[UILabel alloc]init];
            unitCountLabel.text = [NSString stringWithFormat:@"%@ 吨",self.tenderModel.lowest_tons_count];
            unitCountLabel.textColor = [UIColor customRedColor];
            unitCountLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:unitCountLabel];
            
            unitCountLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(unitLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            statusLabel.textColor = [UIColor customGreenColor];
            statusLabel.font = [UIFont boldSystemFontOfSize:16];
            statusLabel.text = @"恭喜你中标了";
            [_headerView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"中标情况";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元",self.tenderModel.winner_price];
            heighPriceLabel.textColor = [UIColor customGreenColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
            UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, SYSTEM_WIDTH, 0.5)];
            lineView3.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView3];
            
        }
            break;
            
            
        case TonTenderFailed:
            
        {
            _headerHight = 150;
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, _headerHight)];
            [self.view addSubview:_headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价结果";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [_headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            self.timeLeft = [self.tenderModel.end_time timeRemaining];
            statusLabel.textColor = [UIColor customRedColor];
            statusLabel.font = [UIFont boldSystemFontOfSize:16];
            statusLabel.text = @"很遗憾你未中标";
            [_headerView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .topSpaceToView(_headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            UILabel *unitLabel = [[UILabel alloc]init];
            unitLabel.text = @"保底吨数";
            unitLabel.textColor = [UIColor grayTextColor];
            unitLabel.font = fontBysize(14);
            [_headerView addSubview:unitLabel];
            
            unitLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *unitCountLabel = [[UILabel alloc]init];
            unitCountLabel.text = [NSString stringWithFormat:@"%@ 吨",self.tenderModel.lowest_tons_count];
            unitCountLabel.textColor = [UIColor customRedColor];
            unitCountLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:unitCountLabel];
            
            unitCountLabel.sd_layout
            .topSpaceToView(_headerView,50)
            .leftSpaceToView(unitLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);

            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"中标情况";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [_headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(_headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = [NSString stringWithFormat:@"%@ 元 （%@）",self.tenderModel.winner_price, [self.tenderModel.driver_winner.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
            
            heighPriceLabel.textColor = [UIColor customRedColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .bottomSpaceToView(_headerView,0)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(_headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView2];
            
            UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, SYSTEM_WIDTH, 0.5)];
            lineView3.backgroundColor = [UIColor customGrayColor];
            [_headerView addSubview:lineView3];
            
        }
            break;
    }
}




#pragma mark ------------>  时间

- (void)timeClockRun{
    self.timeLeft --;
    if (self.timeLeft<0) {
        _timeLeftLabel.text = @"0 天 0 小时 0 分 0 秒";
    }else{
        [self timeLeftString];
    }
    
    if (self.timeLeft%5==0&&(self.tenderStatus == BidTenderOngoing||self.tenderStatus == TonTenderOngoing||self.tenderStatus == BidTenderUnStart||self.tenderStatus == TonTenderUnStart)) {
        [self reloadStatus];
    }
}


- (void)reloadStatus{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:self.tenderModel._id key:@"tender_id"];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    CCWeakSelf(self);
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GET_TENDER_BY_ID parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (!error) {
            TenderModel *newTenderModel = [[TenderModel alloc]initWithDictionary:result error:nil];
            if ([newTenderModel.status isEqualToString:@"unAssigned"]) {
                if ([newTenderModel.driver_winner._id isEqualToString:user_id()]) {
                    if (weakself.tenderStatus == BidTenderUnStart||self.tenderStatus == BidTenderOngoing) {
                        weakself.tenderStatus = BidTenderSucceed;
                    }
                    else if (weakself.tenderStatus == TonTenderUnStart||self.tenderStatus == TonTenderOngoing){
                        weakself.tenderStatus = TonTenderSucceed;
                    }
                }else{
                    if (weakself.tenderStatus == BidTenderUnStart||self.tenderStatus == BidTenderOngoing) {
                        weakself.tenderStatus = BidTenderFailed;
                    }
                    else if (weakself.tenderStatus == TonTenderUnStart||self.tenderStatus == TonTenderOngoing){
                        weakself.tenderStatus = TonTenderFailed;
                    }
                }
                weakself.tenderModel = newTenderModel;
                [weakself.runTimer invalidate];
                weakself.runTimer = nil;
                [weakself initHeaderView];
                [weakself initSumbitView];
            }
        }
    }];

}





- (void)timeLeftString{
    NSString *timeLeftString = [NSString stringWithFormat:@"%ld 天 %ld 小时 %ld 分 %ld 秒",self.timeLeft/86400,(self.timeLeft%86400)/3600,(self.timeLeft%3600)/60,self.timeLeft%60];
    _timeLeftLabel.text = timeLeftString;
}

- (void)initTableView{
    
    self.tableModel = [[TenderDetailTableDataModel alloc]initWithModel:self.tenderModel];
    
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,SYSTITLEHEIGHT+_headerHight)
    .bottomSpaceToView(self.view,_bottomHight);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderDetailCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderDetailHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderDetailHeaderCell"];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark ---> UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.tableModel.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 80;
    }else{
        TenderDetailCellModel *cellModel = [self.tableModel.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        TenderDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderDetailHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell showTenderHeaderCellWithModel:self.tenderModel];
        return cell;
    }else{
        TenderDetailCellModel *cellModel = [self.tableModel.dataArray objectAtIndex:indexPath.row];
        TenderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showCellWithModel:cellModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section==1) {
        TenderDetailCellModel *cellModel = [self.tableModel.dataArray objectAtIndex:indexPath.row];
        if (cellModel.isPhone && ![cellModel.subTitle isEmpty]) {
            callNumber(cellModel.subTitle, self.view);
        }
    }
}


- (void)initSumbitView{
    
    if (_operationView) {
        [_operationView removeFromSuperview];
    }
    
    _operationView = [[UIView alloc]init];
    _operationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_operationView];
    _operationView.layer.borderColor = [UIColor customGrayColor].CGColor;
    _operationView.layer.borderWidth = 0.5;
    switch (self.tenderStatus) {
        case BidTenderUnStart:
        {
            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:inputView];
            
            
            _priceTextField = [[CCTextFiled alloc]init];
            _priceTextField.font = fontBysize(18);
            _priceTextField.placeholder = @"请输入总价格";
            _priceTextField.layer.borderWidth = 0;
            _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            _priceTextField.delegate = self;
             [inputView addSubview:_priceTextField];
            
            _priceTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .bottomEqualToView(inputView)
            .heightIs(60);
            
            
            UIButton * sumbitButton = [[UIButton alloc]init];
            sumbitButton.backgroundColor = [UIColor buttonGreenColor];
            [sumbitButton setTitle:@"出价" forState:UIControlStateNormal];
            [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sumbitButton addTarget:self action:@selector(bidPriceOffer) forControlEvents:UIControlEventTouchUpInside];
            [_operationView addSubview:sumbitButton];
            sumbitButton.sd_layout
            .leftSpaceToView(inputView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [inputView addSubview:lineView1];

            
        }
            break;
        case BidTenderOngoing:
        {

            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:inputView];
            
            
            
            _priceTextField = [[CCTextFiled alloc]init];
            _priceTextField.font = fontBysize(18);
            
            
            NSString *priceString = [NSString stringWithFormat:@"%ld",[self.tenderModel getBindderPrice]];
            NSString *placeHolerSting = [NSString stringWithFormat:@"已出价:%@元 点击修改",priceString];
            NSRange   placeHolerRange = [placeHolerSting rangeOfString:priceString];
            
            NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:placeHolerSting attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            
            // 设置字体和设置字体的范围
            [placeholer addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:16.0f]
                            range:placeHolerRange];
            // 添加文字颜色
            [placeholer addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:placeHolerRange];
            
            
            _priceTextField.attributedPlaceholder = placeholer;
            _priceTextField.layer.borderWidth = 0;
            _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            _priceTextField.delegate = self;
            [inputView addSubview:_priceTextField];
            
            _priceTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .bottomEqualToView(inputView)
            .heightIs(60);
            
            UIButton * sumbitButton = [[UIButton alloc]init];
            sumbitButton.backgroundColor = [UIColor buttonGreenColor];
            [sumbitButton setTitle:@"重新出价" forState:UIControlStateNormal];
            [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sumbitButton addTarget:self action:@selector(bidPriceOffer) forControlEvents:UIControlEventTouchUpInside];
            [_operationView addSubview:sumbitButton];
            sumbitButton.sd_layout
            .leftSpaceToView(inputView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);

            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [inputView addSubview:lineView1];
        }
            break;
        case BidTenderSucceed:
        {
            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:priceView];

            UILabel *priceLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"出价:%ld元",[self.tenderModel getBindderPrice]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [priceString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor customRedColor]
                                range:NSMakeRange(3, priceString.length-4)];
            
            [priceString addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18]
                                range:NSMakeRange(3, priceString.length-4)];
            
            priceLabel.attributedText = priceString;
            
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .bottomEqualToView(priceView)
            .heightIs(60);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已出价";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor naviBlackColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [priceView addSubview:lineView1];
        }
            break;
        case BidTenderFailed:
        {
            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:priceView];
            
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已出价";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor naviBlackColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [priceView addSubview:lineView1];

            
        }
            break;
        case RobTenderUnStart:
        {
            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"运费:%@元",self.tenderModel.current_grab_price] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [priceString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor customRedColor]
                                range:NSMakeRange(3, priceString.length-4)];
            
            [priceString addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18]
                                range:NSMakeRange(3, priceString.length-4)];
            
            priceLabel.attributedText = priceString;

            
            
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UIButton * sumbitButton = [[UIButton alloc]init];
            sumbitButton.backgroundColor = [UIColor customRedColor];
            [sumbitButton setTitle:@"抢单" forState:UIControlStateNormal];
            [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sumbitButton addTarget:self action:@selector(robTender) forControlEvents:UIControlEventTouchUpInside];
            [_operationView addSubview:sumbitButton];
            
            sumbitButton.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
            
        case RobTenderSucceed:
        {
            _bottomHight = 60;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];//
            
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"运费:%@元",self.tenderModel.current_grab_price] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [priceString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor customRedColor]
                                range:NSMakeRange(3, priceString.length-4)];
            
            [priceString addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18]
                                range:NSMakeRange(3, priceString.length-4)];
            
            priceLabel.attributedText = priceString;
            
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已抢到";
            statusLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor naviBlackColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
        case TonTenderUnStart:
        {
            _bottomHight = 120;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:inputView];
            
            
            _unitTextField = [[CCTextFiled alloc]init];
            _unitTextField.font = fontBysize(18);
            _unitTextField.placeholder = @"请输入超额单价/吨";
            _unitTextField.layer.borderWidth = 0;
            _unitTextField.keyboardType = UIKeyboardTypeNumberPad;
            _unitTextField.delegate = self;
            [inputView addSubview:_unitTextField];
            
            _unitTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .bottomEqualToView(inputView)
            .heightIs(60);
            
            
            _priceTextField = [[CCTextFiled alloc]init];
            _priceTextField.font = fontBysize(18);
            _priceTextField.placeholder = @"请输入保底价格";
            _priceTextField.layer.borderWidth = 0;
            _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            _priceTextField.delegate = self;
            [inputView addSubview:_priceTextField];
            
            _priceTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .topEqualToView(inputView)
            .heightIs(60);
            
            
            UIButton * sumbitButton = [[UIButton alloc]init];
            sumbitButton.backgroundColor = [UIColor buttonGreenColor];
            [sumbitButton setTitle:@"出价" forState:UIControlStateNormal];
            [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sumbitButton addTarget:self action:@selector(bidPriceOffer) forControlEvents:UIControlEventTouchUpInside];
            [_operationView addSubview:sumbitButton];
            sumbitButton.sd_layout
            .leftSpaceToView(inputView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [inputView addSubview:lineView1];
            
            
        }
            break;
        case TonTenderOngoing:
        {
            
            _bottomHight = 120;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:inputView];
            
            _unitTextField = [[CCTextFiled alloc]init];
            _unitTextField.font = fontBysize(18);
            
            NSString *unitString = [NSString stringWithFormat:@"%ld",[self.tenderModel getBindderTonPrice]];
            NSString *unitPlaceHolerSting = [NSString stringWithFormat:@"超出单价:%@元/吨 点击修改",unitString];
            NSRange   unitPlaceHolerRange = [unitPlaceHolerSting rangeOfString:unitString];
            
            NSMutableAttributedString *unitPlaceholer = [[NSMutableAttributedString alloc]initWithString:unitPlaceHolerSting attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            
            // 设置字体和设置字体的范围
            [unitPlaceholer addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:16.0f]
                               range:unitPlaceHolerRange];
            // 添加文字颜色
            [unitPlaceholer addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:unitPlaceHolerRange];
            _unitTextField.attributedPlaceholder = unitPlaceholer;
            _unitTextField.layer.borderWidth = 0;
            _unitTextField.keyboardType = UIKeyboardTypeNumberPad;
            _unitTextField.delegate = self;
            [inputView addSubview:_unitTextField];
            
            _unitTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .bottomEqualToView(inputView)
            .heightIs(60);
            
            
            
            _priceTextField = [[CCTextFiled alloc]init];
            _priceTextField.font = fontBysize(18);
            
            
            NSString *priceString = [NSString stringWithFormat:@"%ld",[self.tenderModel getBindderPrice]];
            NSString *placeHolerSting = [NSString stringWithFormat:@"保底价:%@元 点击修改",priceString];
            NSRange   placeHolerRange = [placeHolerSting rangeOfString:priceString];
            
            NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:placeHolerSting attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            
            // 设置字体和设置字体的范围
            [placeholer addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:16.0f]
                               range:placeHolerRange];
            // 添加文字颜色
            [placeholer addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:placeHolerRange];
            
            
            _priceTextField.attributedPlaceholder = placeholer;
            _priceTextField.layer.borderWidth = 0;
            _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            _priceTextField.delegate = self;
            [inputView addSubview:_priceTextField];
            
            _priceTextField.sd_layout
            .leftSpaceToView(inputView,15)
            .rightSpaceToView(inputView,15)
            .topEqualToView(inputView)
            .heightIs(60);
            
            UIButton * sumbitButton = [[UIButton alloc]init];
            sumbitButton.backgroundColor = [UIColor buttonGreenColor];
            [sumbitButton setTitle:@"重新出价" forState:UIControlStateNormal];
            [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sumbitButton addTarget:self action:@selector(bidPriceOffer) forControlEvents:UIControlEventTouchUpInside];
            [_operationView addSubview:sumbitButton];
            sumbitButton.sd_layout
            .leftSpaceToView(inputView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [inputView addSubview:lineView1];
        }
            break;
        case TonTenderSucceed:
        {
            _bottomHight = 120;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:priceView];
            
            
            UILabel *unitLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超出单价:%ld元/吨",[self.tenderModel getBindderTonPrice]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [unitString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor customRedColor]
                               range:NSMakeRange(5, unitString.length-8)];
            
            [unitString addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:18]
                               range:NSMakeRange(5, unitString.length-8)];
            
            unitLabel.attributedText = unitString;
            
            [priceView addSubview:unitLabel];
            
            unitLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .bottomEqualToView(priceView)
            .heightIs(60);
            
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"保底价:%ld元",[self.tenderModel getBindderPrice]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [priceString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor customRedColor]
                                range:NSMakeRange(4, priceString.length-5)];
            
            [priceString addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18]
                                range:NSMakeRange(4, priceString.length-5)];
            
            priceLabel.attributedText = priceString;
            
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .heightIs(60);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已出价";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor naviBlackColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [priceView addSubview:lineView1];
        }
            break;
        case TonTenderFailed:
        {

            _bottomHight = 120;
            _operationView.frame = CGRectMake(-1, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH+2, _bottomHight+1);
            
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, _bottomHight)];
            [_operationView addSubview:priceView];
            
            
            UILabel *unitLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超出单价:%ld元/吨",[self.tenderModel getBindderTonPrice]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [unitString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor customRedColor]
                               range:NSMakeRange(5, unitString.length-8)];
            
            [unitString addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:18]
                               range:NSMakeRange(5, unitString.length-8)];
            
            unitLabel.attributedText = unitString;
            
            [priceView addSubview:unitLabel];
            
            unitLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .bottomEqualToView(priceView)
            .heightIs(60);
            
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"保底价:%ld元",[self.tenderModel getBindderPrice]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayTextColor]}];
            [priceString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor customRedColor]
                                range:NSMakeRange(4, priceString.length-5)];
            
            [priceString addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18]
                                range:NSMakeRange(4, priceString.length-5)];
            
            priceLabel.attributedText = priceString;
            
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,24)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .heightIs(60);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已出价";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor naviBlackColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH-120, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [priceView addSubview:lineView1];
            
            
        }
            break;
    }
    
}


#pragma mark ---------> 出价
- (void)bidPriceOffer{
    
    
    
    if (self.tenderStatus == TonTenderUnStart||self.tenderStatus == TonTenderOngoing) {
        
        if ([_priceTextField.text isEmpty]) {
            toast_showInfoMsg(@"请输入保底价格", 300);
            return;
        }
        
        if ([_unitTextField.text isEmpty]) {
            toast_showInfoMsg(@"请输入超出单价/吨", 300);
            return;
        }
        
    }else{
        if ([_priceTextField.text isEmpty]) {
            toast_showInfoMsg(@"请输入价格", 300);
            return;
        }
    }
    
    if (_priceTextField.text.integerValue>self.tenderModel.highest_protect_price.integerValue) {
        toast_showInfoMsg(@"大于最高价，请重新输入", 300);
        return;
    }
    if (_priceTextField.text.integerValue<self.tenderModel.lowest_protect_price.integerValue) {
        NSString *lowPricre = [NSString stringWithFormat:@"小于最低价格%@",self.tenderModel.lowest_protect_price];
        toast_showInfoMsg(lowPricre, 300);
        return;
    }
    
    if (![self.tenderModel.status isEqualToString:@"comparing"]) {
        [self naviBack];
        toast_showInfoMsg(@"比价未开始或已结束，请重试", 200);
        return;
    }
//    [self.view endEditing:YES];
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *robItem = [RIButtonItem itemWithLabel:@"确认" action:^{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters put:accessToken() key:ACCESS_TOKEN];
        [parameters put:self.tenderModel._id key:@"tender_id"];
        [parameters put:_priceTextField.text key:@"price"];
        [parameters put:_unitTextField.text key:@"price_per_ton"];
        [SVProgressHUD showWithStatus:@"正在出价..."];
        [[HttpRequstManager requestManager] postWithRequestBodyString:USER_COMPARE_TENDER parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"出价失败")];
                [_weakSelf naviBack];
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"出价成功"];
                
                TenderModel *newTenderModel = [[TenderModel alloc]initWithDictionary:[result objectForKey:@"tender"] error:nil];
                _weakSelf.tenderModel = newTenderModel;
                
                if (_weakSelf.tenderStatus == BidTenderUnStart) {
                    _weakSelf.tenderStatus = BidTenderOngoing;
                }
                else if (_weakSelf.tenderStatus == TonTenderUnStart){
                    _weakSelf.tenderStatus = TonTenderOngoing;
                }
                [_weakSelf initSumbitView];
            }
        }];
        
    }];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"比价确认"
                                                        message:@"你确定要出价吗？比价成功后违约将扣除你的保证金"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:robItem, nil];
    
    [alertView show];
    
}
- (void)robTender{

    //    [self gotoMediatorProgress];
    
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *robItem = [RIButtonItem itemWithLabel:@"确认" action:^{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters put:accessToken() key:ACCESS_TOKEN];
        [parameters put:self.tenderModel._id key:@"tender_id"];
        [SVProgressHUD showWithStatus:@"正在抢单..."];
        [[HttpRequstManager requestManager] postWithRequestBodyString:USER_GRAB_TENDER parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"抢单失败")];
            }else{
                [SVProgressHUD dismiss];
                _weakSelf.tenderModel.status = @"unAssigned";
                _weakSelf.tenderStatus = RobTenderSucceed;
                [_weakSelf initSumbitView];
                [_weakSelf robTenderSucceed];
            }
        }];

    }];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抢单确认"
                                                        message:@"你确定要抢单吗？抢单成功后违约将扣除你的保证金"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:robItem, nil];
    [alertView show];
    
}
- (void)robTenderSucceed{
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *seletdCarItem = [RIButtonItem itemWithLabel:@"选择车辆" action:^{
        MyDriversViewController *myDrvier = [[MyDriversViewController alloc]initWithAssaginTenderModel:self.tenderModel];
        myDrvier.isFormDetail = YES;
        [_weakSelf.navigationController pushViewController:myDrvier animated:YES];
    }];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
//        [_weakSelf naviBack];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抢单成功"
                                                        message:@"恭喜你抢单成功，请选择车辆与绑定油卡的操作，“取消”则稍后操作"
                                               cancelButtonItem:nil
                                               otherButtonItems:cancelItem,seletdCarItem, nil];
    [alertView show];

}

- (void)compareSucceed{
    
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"返回" action:^{
        [_weakSelf naviBack];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出价成功"
                                                        message:@"恭喜你出价成功"
                                               cancelButtonItem:nil
                                               otherButtonItems:cancelItem, nil];
    [alertView show];
}


- (void)gotoMediatorProgress{
    NSArray *viewControllers;
    NSArray *titles;
    NSString *title;
    viewControllers = @[[MediatorPendingViewController class],[MediatorTransportingViewController class],[MediatorFinishedViewController class]];
    titles = @[@"待处理",@"运输中",@"已完成"];
    title = @"比价、抢单中";
    MediatorProgressViewController *pageVC = [[MediatorProgressViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.menuItemWidth = [UIScreen mainScreen].bounds.size.width/titles.count;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    pageVC.menuHeight = 36;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.menuBGColor = [UIColor naviBlackColor];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self.view bringSubviewToFront:_operationView];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    CGRect frame = CGRectMake(0, SYSTEM_HEIGHT-_bottomHight-keyboardHeight, SYSTEM_WIDTH, _bottomHight);
    [UIView animateWithDuration:0.25 animations:^{
        _operationView.frame = frame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.25 animations:^{
        _operationView.frame = CGRectMake(0, SYSTEM_HEIGHT-_bottomHight, SYSTEM_WIDTH, _bottomHight);
    }];
}


#pragma mark ---> 返回 其他
- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    CCLog(@"%@------->delloc",self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.runTimer invalidate];
     self.runTimer = nil;
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
