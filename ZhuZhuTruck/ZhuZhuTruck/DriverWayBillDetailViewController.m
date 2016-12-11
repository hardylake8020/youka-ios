//
//  DriverWayBillDetailViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverWayBillDetailViewController.h"
#import "WayBillDetailCell.h"
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WaybillDetailTableDataModel.h"
#import "DriverOperationViewController.h"
@interface DriverWayBillDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    OperationButton*    _halfwaybutton;
    OperationButton*    _signInbutton;
    OperationButton*    _scanbutton;
}
@property (nonatomic, assign) OrderModel *orderModel;
@property (nonatomic, assign) WaybillStatus status;
@property (nonatomic, strong) WaybillDetailTableDataModel *tableModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *operationView;
@end

@implementation DriverWayBillDetailViewController

- (instancetype)initWithWillbillStaus:(WaybillStatus)status
{
    self = [super init];
    if (self) {
        self.status = status;
    }
    return self;
}

- (instancetype)initWithWillbillStaus:(WaybillStatus)status andOrderModel:(OrderModel *)orderModel
{
    self = [super init];
    if (self) {
        self.status = status;
        self.orderModel = orderModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviHeaderViewWithTitle:@"运单详情"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTableView];
    
    if (self.status == SucceedDelvieryStatus) {
        return;
    }
    [self initOperationItems];
    [self initSumbitView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.orderModel.status isEqualToString:@"unPickuped"]||[self.orderModel.status isEqualToString:@"unDeliveried"]) {
        [_signInbutton setSelectedTitle:@"已进场"];
    }
    
    if (self.orderModel.scanCodes.count>0) {
        [_scanbutton setSelectedTitle:@"已扫码"];
    }
    
//    if ([self.orderModel.status isEqualToString:@"unPickupSigned"]) {
//        
//    }else if ([self.orderModel.status isEqualToString:@"unPickuped"]) {
//        
//    }else if ([self.orderModel.status isEqualToString:@"unDeliverySigned"]) {
//        
//    }else if ([self.orderModel.status isEqualToString:@"unDeliveried"]) {
//        
//    }else if ([self.orderModel.status isEqualToString:@"completed"]) {
//        
//    }
}

- (void)initTableView{
    
    self.tableModel = [[WaybillDetailTableDataModel alloc]initWithModel:self.orderModel];
    
    CGFloat bottomHight = 150;
    if (self.status == SucceedDelvieryStatus) {
        bottomHight = 0;
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-bottomHight )];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WayBillDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WayBillDetailCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
}

- (void)initOperationItems{
    
    
    
    self.operationView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-150, SYSTEM_WIDTH, 100)];
    self.operationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.operationView];
    _halfwaybutton = [[OperationButton alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH/3, 100) buttonType:ZHONGTUBUTTON buttonText:@"中途事件" isSeleted:NO];
    [_halfwaybutton addTarget:self action:@selector(gotoHalfWayEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:_halfwaybutton];
    
    _signInbutton  = [[OperationButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3, 0, SYSTEM_WIDTH/3, 100) buttonType:JINCHANGBUTTON buttonText:@"进场" isSeleted:NO];
    [_signInbutton addTarget:self action:@selector(gotoSignIn) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:_signInbutton];
    
    _scanbutton    = [[OperationButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/3*2, 0, SYSTEM_WIDTH/3, 100) buttonType:SAOYISAOBUTTON buttonText:@"扫一扫" isSeleted:NO];
    [_scanbutton addTarget:self action:@selector(gotoScanCode) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:_scanbutton];
}


#pragma mark ---> UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.tableModel.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaybillDetailCellModel *cellModel = [[self.tableModel.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cellModel.cellHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MarginLabel *choiceTipLabel = [[MarginLabel alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 30) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    choiceTipLabel.backgroundColor = ColorFromRGB(0xf5f5f5);
    choiceTipLabel.font = fontBysize(16);
    switch (section) {
        case 0:
            choiceTipLabel.text = @"运单详情";
            break;
        case 1:
            choiceTipLabel.text = @"提货信息";
            break;
        case 2:
            choiceTipLabel.text = @"交货信息";
            break;
        default:
            break;
    }
    choiceTipLabel.textColor = UIColorFromRGB(0x999999);
    return choiceTipLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaybillDetailCellModel *cellModel = [[self.tableModel.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    WayBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WayBillDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showCellWithModel:cellModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WaybillDetailCellModel *cellModel = [[self.tableModel.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cellModel.isPhone && ![cellModel.subTitle isEmpty]) {
        callNumber(cellModel.subTitle, self.view);
    }
}
- (void)gotoScanCode{
    CCWeakSelf(self);
    QRCodeVC *scan = [[QRCodeVC alloc]initWithCallBackHandler:^(NSString *codeString) {
        NSLog(@"codeString----> %@", codeString);
        if ([codeString isEmpty]) {
            toast_showInfoMsg(@"扫码失败", 200);
            return ;
        }
        if (!weakself.orderModel.scanCodes) {
            weakself.orderModel.scanCodes = [NSMutableArray arrayWithObject:codeString];
        }else if(![weakself.orderModel.scanCodes containsObject:codeString]){
            [weakself.orderModel.scanCodes addObject:codeString];
        }else{
            toast_showInfoMsg(@"条码已存在", 200);
        }
    }];
    [self presentViewController:scan animated:YES completion:nil];
}
- (void)gotoSignIn{
    if (self.status == UnpickupedStatus) {
        DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSign andOrderModel:self.orderModel];
        [self.navigationController pushViewController:operation animated:YES];
    }else if (self.status == UndeliveryedStatus) {
        DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:DeliveySign andOrderModel:self.orderModel];
        [self.navigationController pushViewController:operation animated:YES];
    }
}
- (void)gotoHalfWayEvent{
    
    DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:HalfWayEvent andOrderModel:self.orderModel];
    [self.navigationController pushViewController:operation animated:YES];
    
}

#pragma mark ----> 上报按钮

- (void)initSumbitView{
    NSString *title;
    if (self.status == UnpickupedStatus) {
        title = @"确认提货";
    }else if (self.status == UndeliveryedStatus) {
        title = @"确认交货";
    }
    UIButton *sumbitButton = [CCButton ButtonWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50) cornerradius:0 title:title titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(sumbitClick)];
    [self.view addSubview:sumbitButton];
}

- (void)sumbitClick{
    if (self.status == UnpickupedStatus) {
        
        if (self.orderModel.pickup_photo_force.boolValue) {
            __weak typeof(self) _weakSelf = self;
            RIButtonItem *pickUpsign = [RIButtonItem itemWithLabel:@"进场" action:^{
                [_weakSelf gotoSignIn];
            }];
            
            RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
               
            }];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                                message:@"你还没提货进场，请先提货进场！"
                                                       cancelButtonItem:nil
                                                       otherButtonItems:cancelItem,pickUpsign, nil];
            [alertView show];

        }else{
            DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:PickupSucceed andOrderModel:self.orderModel];
            [self.navigationController pushViewController:operation animated:YES];
        }
        
    }else if (self.status == UndeliveryedStatus) {
        if (self.orderModel.pickup_photo_force.boolValue) {
            __weak typeof(self) _weakSelf = self;
            RIButtonItem *pickUpsign = [RIButtonItem itemWithLabel:@"进场" action:^{
                [_weakSelf gotoSignIn];
            }];
            
            RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{
                
            }];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                                message:@"你还没交货进场，请先交货进场！"
                                                       cancelButtonItem:nil
                                                       otherButtonItems:cancelItem,pickUpsign, nil];
            [alertView show];
            
        }else{
            DriverOperationViewController *operation = [[DriverOperationViewController alloc]initWithDriverOperationType:DeliveySucceed andOrderModel:self.orderModel];
            [self.navigationController pushViewController:operation animated:YES];
        }
    }
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
