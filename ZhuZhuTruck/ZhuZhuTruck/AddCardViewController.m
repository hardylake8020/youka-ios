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
    CCTextFiled *_cardNumberFiled;
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
    if (self.addType == ADD_ETC_CARD) {
        [self addBlackNaviHaderViewWithTitle:@"添加ETC卡"];
    }else if (self.addType == ADD_OIL_CARD) {
        [self addBlackNaviHaderViewWithTitle:@"添加油卡"];
    }
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initAddView];
}
- (void)initAddView{
    _cardNumberFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,SYSTITLEHEIGHT+50, SYSTEM_WIDTH-40, 40)];
    [_cardNumberFiled setKeyboardType:UIKeyboardTypeNumberPad];
    _cardNumberFiled.delegate = self;
    
    if (self.addType == ADD_ETC_CARD) {
        [_cardNumberFiled setPlaceholder:@"请输入ETC卡卡号"];
    }else if (self.addType == ADD_OIL_CARD) {
        [_cardNumberFiled setPlaceholder:@"请输入油卡卡号"];
    }
    _cardNumberFiled.delegate = self;
    _cardNumberFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_cardNumberFiled];
    
    
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,SYSTEM_HEIGHT-100, SYSTEM_WIDTH-40, 50) cornerradius:CORNERRADIUS title:@"添加" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(addCardCall)];
    [self.view addSubview:loginButton];


}

- (void)addCardCall{
    
    if ([_cardNumberFiled.text isEmpty]) {
        toast_showInfoMsg(@"请填写卡号", 200);
        return;
    }
    
//    CCWeakSelf(self);
    
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
