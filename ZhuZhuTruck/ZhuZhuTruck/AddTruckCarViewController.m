//
//  AddTruckCarViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/21.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AddTruckCarViewController.h"

@interface AddTruckCarViewController ()<UITextFieldDelegate>
{
    CCTextFiled *_phoneNumberFiled;
}

@end

@implementation AddTruckCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"添加车辆"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initAddView];
}
- (void)initAddView{
    _phoneNumberFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,SYSTITLEHEIGHT+50, SYSTEM_WIDTH-40, 40)];
    [_phoneNumberFiled setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumberFiled.delegate = self;
    [_phoneNumberFiled setPlaceholder:@"请输入司机手机号"];
    _phoneNumberFiled.delegate = self;
    _phoneNumberFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumberFiled];
    
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,SYSTEM_HEIGHT-100, SYSTEM_WIDTH-40, 50) cornerradius:CORNERRADIUS title:@"添加" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(addCardCall)];
    [self.view addSubview:loginButton];
    
}

- (void)addCardCall{
    
    if (![_phoneNumberFiled.text isValidateMobile]) {
        toast_showInfoMsg(@"请填写正确的手机号", 200);
        return;
    }
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *truckInfo  = [NSMutableDictionary dictionary];
    
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [truckInfo put:_phoneNumberFiled.text key:@"driver_number"];
    
    [truckInfo put:@"沪BAT8888" key:@"truck_number"];
    
    [truckInfo put:@"金杯车" key:@"truck_type"];
    
    [parameters put:truckInfo key:@"truck_info"];
    
    [SVProgressHUD showWithStatus:@"正在添加..."];
    
    [[HttpRequstManager requestManager] postWithRequestBodyString:USER_ADD_TRUCK_CAR parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
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
