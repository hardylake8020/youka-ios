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
#import "TenderDetailTableDataModel.h"
@interface MediatorOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    CGFloat _headerHight;
    UIView *_operationView;
    CCTextFiled *_priceTextField;
}
@property (nonatomic, assign) TenderOrderStatus tenderStatus;
@property (nonatomic, strong) TenderDetailTableDataModel *tableModel;
@property (nonatomic, strong) UITableView *tableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.tenderStatus) {
        case BidTenderUnStart:
        case BidTenderOngoing:
        case BidTenderSucceed:
        case BidTenderFailed:{
            [self addNaviHeaderViewWithTitle:@"比价详情"];
        }
            break;
        case RobTenderUnStart:
        case RobTenderOngoing:
        case RobTenderSucceed:
        case RobTenderFailed:{
            [self addNaviHeaderViewWithTitle:@"抢单详情"];
        }
            break;
    }
    
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initHeaderView];
    [self initTableView];
    [self initSumbitView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)initHeaderView{

    
    switch (self.tenderStatus) {
        case BidTenderUnStart:
        case BidTenderOngoing:
        {
            _headerHight = 100;
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, 100)];
            [self.view addSubview:headerView];
            UILabel *bidTimeLabel = [[UILabel alloc]init];
            bidTimeLabel.text = @"比价剩余时间";
            bidTimeLabel.textColor = [UIColor grayTextColor];
            bidTimeLabel.font = fontBysize(14);
            [headerView addSubview:bidTimeLabel];
            
            bidTimeLabel.sd_layout
            .topSpaceToView(headerView,0)
            .leftSpaceToView(headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *timeLeftLabel = [[UILabel alloc]init];
            timeLeftLabel.text = @"02 天 01 小时 03 分 45 秒";
            timeLeftLabel.textColor = [UIColor customRedColor];
            timeLeftLabel.font = [UIFont boldSystemFontOfSize:16];
            [headerView addSubview:timeLeftLabel];
            
            timeLeftLabel.sd_layout
            .topSpaceToView(headerView,0)
            .leftSpaceToView(bidTimeLabel,15)
            .rightSpaceToView(headerView,15)
            .heightIs(50);
            
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"出价不得高于";
            priceLabel.textColor = [UIColor grayTextColor];
            priceLabel.font = fontBysize(14);
            [headerView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .topSpaceToView(headerView,50)
            .leftSpaceToView(headerView,15)
            .widthIs(90)
            .heightIs(50);
            
            UILabel *heighPriceLabel = [[UILabel alloc]init];
            heighPriceLabel.text = @"13000元";
            heighPriceLabel.textColor = [UIColor customRedColor];
            heighPriceLabel.font = [UIFont boldSystemFontOfSize:16];
            [headerView addSubview:heighPriceLabel];
            
            heighPriceLabel.sd_layout
            .topSpaceToView(headerView,50)
            .leftSpaceToView(priceLabel,15)
            .rightSpaceToView(headerView,15)
            .heightIs(50);
            
            
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor customGrayColor];
            [headerView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor customGrayColor];
            [headerView addSubview:lineView2];
            
        }
            break;
        case BidTenderSucceed:
  
        case BidTenderFailed:

        case RobTenderUnStart:

        case RobTenderOngoing:

        case RobTenderSucceed:

        case RobTenderFailed:
        {
            _headerHight = 0;
        }
            break;
    }

}
- (void)initTableView{
    
    self.tableModel = [[TenderDetailTableDataModel alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTEM_TITLE_HEIGHT+_headerHight, SYSTEM_WIDTH, SYSTEM_HEIGHT-60-SYSTEM_TITLE_HEIGHT-_headerHight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderDetailCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TenderDetailHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TenderDetailHeaderCell"];
    
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:self.tableView];
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
        return 100;
    }else{
        TenderDetailCellModel *cellModel = [self.tableModel.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        TenderDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderDetailHeaderCell"];
        return cell;
    }else{
        TenderDetailCellModel *cellModel = [self.tableModel.dataArray objectAtIndex:indexPath.row];
        TenderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenderDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showCellWithModel:cellModel];
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
    _operationView = [[UIView alloc]initWithFrame:CGRectMake(-1, SYSTEM_HEIGHT-60, SYSTEM_WIDTH+2, 60)];
    _operationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_operationView];
    _operationView.layer.borderColor = [UIColor customGrayColor].CGColor;
    _operationView.layer.borderWidth = 0.5;

    switch (self.tenderStatus) {
        case BidTenderUnStart:
        {
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
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
            .topEqualToView(inputView)
            .bottomEqualToView(inputView);
            
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
            
        }
            break;
        case BidTenderOngoing:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"出价：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已出价";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor buttonGreenColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
            
        }
            break;
        case BidTenderSucceed:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"出价：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"比价中标";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor buttonGreenColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
        case BidTenderFailed:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"出价：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"比价未中标";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor customRedColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
        case RobTenderUnStart:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"运费：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
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
        case RobTenderOngoing:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"运费：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"已抢标";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor customRedColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
        case RobTenderSucceed:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"运费：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"抢标中标";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor customRedColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
        case RobTenderFailed:
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, SYSTEM_WIDTH-120, 60)];
            [_operationView addSubview:priceView];
            
            UILabel *priceLabel = [[UILabel alloc]init];
            priceLabel.text = @"运费：3000 元";
            priceLabel.font = fontBysize(18);
            priceLabel.textColor = [UIColor darkTextColor];
            [priceView addSubview:priceLabel];
            
            priceLabel.sd_layout
            .leftSpaceToView(priceView,15)
            .rightSpaceToView(priceView,15)
            .topEqualToView(priceView)
            .bottomEqualToView(priceView);
            
            UILabel *statusLabel = [[UILabel alloc]init];
            statusLabel.text = @"抢标未中标";
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.font = fontBysize(18);
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.backgroundColor = [UIColor customRedColor];
            [_operationView addSubview:statusLabel];
            
            statusLabel.sd_layout
            .leftSpaceToView(priceView,0)
            .topEqualToView(_operationView)
            .bottomEqualToView(_operationView)
            .rightSpaceToView(_operationView,1);
        }
            break;
    }
    
}

- (void)bidPriceOffer{
    
}
- (void)robTender{
    
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
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    CGRect frame = CGRectMake(0, SYSTEM_HEIGHT-60-keyboardHeight, SYSTEM_WIDTH, 60);
    [UIView animateWithDuration:0.25 animations:^{
        _operationView.frame = frame;
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.25 animations:^{
        _operationView.frame = CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60);
    }];
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