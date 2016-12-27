//
//  AddCardViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/20.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()<UITextFieldDelegate>
{
    UITextField *_cardNumberFiled;
}
@property (nonatomic, assign) UserAddCardType addType;
@end

@implementation AddCardViewController

- (instancetype)initWithType:(UserAddCardType)type
{
    self = [super init];
    if (self) {
        self.addType = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    if (self.addType == ADD_ETC_CARD) {
        [self addBlackNaviHaderViewWithTitle:@"添加ETC卡"];
    }else if (self.addType == ADD_OIL_CARD) {
        [self addBlackNaviHaderViewWithTitle:@"添加油卡"];
    }
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initAddView];
}
- (void)initAddView{
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(-1, SYSTITLEHEIGHT+20, SYSTEM_WIDTH+2, 50)];
    addView.layer.borderColor = [UIColor customGrayColor].CGColor;
    addView.layer.borderWidth = 0.5;
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];

    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    tipLabel.font = fontBysize(16);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 1, 50)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    _cardNumberFiled = [[UITextField alloc]initWithFrame:CGRectMake(140,0, SYSTEM_WIDTH-140, 50)];
    _cardNumberFiled.clearButtonMode = UITextFieldViewModeAlways;
    
    if (self.addType == ADD_ETC_CARD) {
        [_cardNumberFiled setPlaceholder:@"请输入ETC卡卡号"];
        tipLabel.text = @"ETC卡号";
    }else if (self.addType == ADD_OIL_CARD) {
        tipLabel.text = @"油卡卡号";
        [_cardNumberFiled setPlaceholder:@"请输入油卡卡号"];
    }
    _cardNumberFiled.delegate = self;
    _cardNumberFiled.keyboardType = UIKeyboardTypeNumberPad;
    _cardNumberFiled.font = fontBysize(16);
    [addView addSubview:_cardNumberFiled];
    
    
    UIButton * addCadButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    addCadButton.backgroundColor = [UIColor buttonGreenColor];
    [addCadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [addCadButton setTitle:@"添加" forState:UIControlStateNormal];
    [addCadButton addTarget:self action:@selector(addCardCall) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:addCadButton];
}

- (void)addCardCall{
    
    if ([_cardNumberFiled.text isEmpty]) {
        toast_showInfoMsg(@"请填写卡号", 200);
        return;
    }
    
    CCWeakSelf(self);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *cardInfo  = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    [cardInfo put:_cardNumberFiled.text key:@"number"];
    if (self.addType == ADD_ETC_CARD) {
        [cardInfo put:@"etc" key:@"type"];
    }else if (self.addType == ADD_OIL_CARD) {
        [cardInfo put:@"unEtc" key:@"type"];
    }
    [parameters put:cardInfo key:@"card_info"];
    
    [SVProgressHUD showWithStatus:@"正在添加..."];
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_ADD_CARD parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"添加失败")];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [weakself naviBack];
        }
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
