//
//  RegisterViewController.m
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "RegisterViewController.h"
#import "PooCodeView.h"
#import "LoginViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    RegisterType _type;
    CCTextFiled *_phoneNumberFiled;
    CCTextFiled *_vifiyCodeFiled;
    CCTextFiled *_firstPassWordFiled;
    CCTextFiled *_secondPassWordFiled;
    PooCodeView *_pooCodeView;
    UIButton    *_smsCodeButton;
    UIView      *view_back;
}
@end

@implementation RegisterViewController
- (instancetype)initWithRegisterType:(RegisterType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    view_back = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view_back];
    view_back.backgroundColor = ColorFromRGB(0xf5f5f5);
    
    if (_type == REGISTER_TRUCK_MAN) {
        [self addBlackNaviHaderViewWithTitle:@"注册司机"];
    }else{
        [self addBlackNaviHaderViewWithTitle:@"忘记密码"];
    }
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTextFileds];
    [self initSubmitView];
    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)initTextFileds{
    
    int height = SYSTITLEHEIGHT+50;
    _phoneNumberFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, view_back.frame.size.width-40, 40)];
    [_phoneNumberFiled setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumberFiled.delegate = self;
    [_phoneNumberFiled setPlaceholder:@"请输入手机号"];
    _phoneNumberFiled.delegate = self;
    [view_back addSubview:_phoneNumberFiled];
    
    height+=50;
    _vifiyCodeFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, view_back.frame.size.width-40-110, 40)];
    [_vifiyCodeFiled setPlaceholder:@"请输入验证码"];
    _vifiyCodeFiled.delegate = self;
    [view_back addSubview:_vifiyCodeFiled];
    
    if (_type == REGISTER_TRUCK_MAN) {
        
        [_vifiyCodeFiled setKeyboardType:UIKeyboardTypeASCIICapable];
        [_vifiyCodeFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
        _pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(view_back.frame.size.width-20-100,height, 100, 40)];
        _pooCodeView.clipsToBounds = YES;
        _pooCodeView.layer.cornerRadius = CORNERRADIUS;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_pooCodeView addGestureRecognizer:tap];
        [view_back addSubview:_pooCodeView];

    }else{
        [_vifiyCodeFiled setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        _vifiyCodeFiled.delegate = self;
        _smsCodeButton = [CCButton ButtonWithFrame:CGRectMake(view_back.frame.size.width-20-100,height, 100, 40) cornerradius:CORNERRADIUS title:@"发送验证码" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:13] normalBackGrondImage:[UIImage imageNamed:@"4285f4"] highLightImage:[UIImage imageNamed:@"376FCD"] target:self action:@selector(sendSmsCode)];
        [view_back addSubview:_smsCodeButton];
    }
    
    
    height+=50;
    _firstPassWordFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, view_back.frame.size.width-40, 40)];
    
    [_firstPassWordFiled setKeyboardType:UIKeyboardTypeEmailAddress];
    [_firstPassWordFiled setPlaceholder:@"请输入密码"];
    [_firstPassWordFiled setSecureTextEntry:YES];
    [_firstPassWordFiled setClearsOnBeginEditing:YES];
    _firstPassWordFiled.delegate = self;
    [view_back addSubview:_firstPassWordFiled];
    
    height+=50;
    _secondPassWordFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, view_back.frame.size.width-40, 40)];
    
    [_secondPassWordFiled setKeyboardType:UIKeyboardTypeEmailAddress];
    [_secondPassWordFiled setPlaceholder:@"请再次输入密码"];
    [_secondPassWordFiled setSecureTextEntry:YES];
    [_secondPassWordFiled setClearsOnBeginEditing:YES];
    _secondPassWordFiled.delegate = self;
    [view_back addSubview:_secondPassWordFiled];
}

- (void)initSubmitView{
    NSString *buttonTitle;
    if (_type == REGISTER_TRUCK_MAN) {
        buttonTitle = @"注册";
    }else{
        buttonTitle = @"重置";
    }
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,SYSTEM_HEIGHT-150, SYSTEM_WIDTH-40, 50) cornerradius:CORNERRADIUS title:buttonTitle titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(loginButtonClick)];
    [self.view addSubview:loginButton];
    
    
    if (_type == REGISTER_TRUCK_MAN) {
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.font =fontBysize(10);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"注册即表示您同意《柱柱整车服务协议》";
        tipLabel.textColor = UIColorFromRGB(0x757575);
        [self.view addSubview:tipLabel];
        
        tipLabel.sd_layout
        .autoHeightRatio(0)
        .leftEqualToView (self.view)
        .rightEqualToView (self.view)
        .bottomSpaceToView (loginButton,10);
    }

//    UILabel* help=[[UILabel alloc] initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-30, SYSTEM_WIDTH, 20)];
//    [help setText:@"如有问题请拨打400-886-9256客服电话"];
//    [help setFont:fontBysize(10)];
//    [help setTextAlignment:NSTextAlignmentCenter];
//    UIColor *color = UIColorFromRGB(0x757575);
//    [help setTextColor:color];
//    [self.view addSubview:help];
}

- (void)tapClick:(UITapGestureRecognizer*)tap{
    [_pooCodeView changeCode];
    NSLog(@"%@",_pooCodeView.changeString);
}
- (void)sendSmsCode{
    
}
#pragma mark --------> 注册或修改密码
- (void)loginButtonClick{
    
    
    if ([_phoneNumberFiled.text isEmpty]||![_phoneNumberFiled.text isValidateMobile]) {
        toast_showInfoMsg(@"手机号码不符合规范", 200);
        return;
    }
    if (_type == REGISTER_TRUCK_MAN) {
        if ([_vifiyCodeFiled.text isEmpty]||![[_vifiyCodeFiled.text lowercaseString] isEqualToString:[_pooCodeView.changeString lowercaseString]]) {
            toast_showInfoMsg(@"请输入正确的验证码", 200);
            return;
        }
    }else{
        if ([_vifiyCodeFiled.text isEmpty]) {
            toast_showInfoMsg(@"请输入验证码", 200);
            return;
        }
    }
    if ([_firstPassWordFiled.text isEmpty]||_firstPassWordFiled.text.length<6) {
        toast_showInfoMsg(@"密码少于6位", 200);
        return;
    }
    if (![_firstPassWordFiled.text isEqualToString:_secondPassWordFiled.text]) {
        toast_showInfoMsg(@"两次密码不一致", 200);
        return;
    }
    if (_type == REGISTER_TRUCK_MAN) {
        [self registerUserAccount];
    }else{
        [self chagePassWord];
    }
}

- (void)registerUserAccount{
    __weak typeof(self) _weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:_phoneNumberFiled.text key:USERNAME];
    [parameters put:_firstPassWordFiled.text key:PWD];
    [SVProgressHUD showWithStatus:@"正在注册"];
    [[DiverHttpRequstManager requestManager] postWithRequestBodyString:SIGN_UP parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"请求失败")];
        }else{
            [_weakSelf succeedDone];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        }
    }];
}
- (void)chagePassWord{
    __weak typeof(self) _weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:_phoneNumberFiled.text key:USERNAME];
    [parameters put:_firstPassWordFiled.text key:PWD];
    [SVProgressHUD showWithStatus:@"正在修改中"];
    [[DiverHttpRequstManager requestManager] postWithRequestBodyString:SIGN_UP parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"请求失败")];
        }else{
            [_weakSelf succeedDone];
            [SVProgressHUD showSuccessWithStatus:@"重置成功"];
        }
    }];

}

- (void)succeedDone{
    
    save_UserPwd(_firstPassWordFiled.text);
    save_userPhone(_phoneNumberFiled.text);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark ---> 返回 其他
- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int keyboardHeight = keyboardRect.size.height;
//    CGRect frame = CGRectMake(0, SYSTEM_HEIGHT-60-keyboardHeight, SYSTEM_WIDTH, 60);
//    [UIView animateWithDuration:0.25 animations:^{
//        //_textMarkView.frame = frame;
//    }];
//    
//}
//- (void)keyboardWillHide:(NSNotification *)aNotification{
//    [UIView animateWithDuration:0.25 animations:^{
//        //_textMarkView.frame = CGRectMake(0, SYSTEM_HEIGHT-110, SYSTEM_WIDTH, 60);
//    }];
//}


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
