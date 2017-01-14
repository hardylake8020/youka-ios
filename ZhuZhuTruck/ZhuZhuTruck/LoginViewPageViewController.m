//
//  LoginViewPageViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/26.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "LoginViewPageViewController.h"
#import "HomePageViewController.h"
#import "RegisterViewController.h"

@interface LoginViewPageViewController ()<UITextFieldDelegate>{
    UIImageView *_lauchImage;
    UITextField *phoneTextField;
    UITextField *passWordTextFied;
}

@end

@implementation LoginViewPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:16]];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self initLoginView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRegistedId) name:GET_JPUSH_REGISEDID_NOTI object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [phoneTextField setText:user_phone()];
    [self autoLogin];
}

- (void)uploadRegistedId{
    
    //    if ([AppDelegate shareAppDelegate].userRole!=TRUCK_MAN) {
    //        return;
    //    }
    //    NSString *regesterId = [JPUSHService registrationID];
    //    NSString *token = accessToken();
    //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    if ([regesterId isEmpty]||!regesterId||[token isEmpty]||!token) {
    //        return;
    //    }
    //
    //    [parameters put:regesterId key:@"push_id"];
    //    [parameters put:token key:ACCESS_TOKEN];
    //    [[HttpRequstManager requestManager] postWithRequestBodyString:UPDATE_PUSH_ID parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
    //        if (error) {
    //        }else{
    //            CCLog(@"token_upload_result:%@",result);
    //            save_PushId(regesterId);
    //        }
    //    }];
}

- (void)initLoginView{
    
    CGFloat forSmallScreen = 1;
    if (SYSTEM_WIDTH<=320) {
        forSmallScreen = 0.8;
    }
    
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
    backImageView.frame = self.view.bounds;
    [backImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backImageView];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [backImageView addSubview:iconImageView];
    
    iconImageView.sd_layout
    .centerXEqualToView(backImageView)
    .topSpaceToView(backImageView, 85)
    .widthIs(100*forSmallScreen)
    .heightIs(100*forSmallScreen);
    
    phoneTextField=[[UITextField alloc] initWithFrame:CGRectMake(40,230,SYSTEM_WIDTH-80, 50)];
    [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    phoneTextField.delegate = self;
    [phoneTextField setText:user_phone()];
    phoneTextField.textColor = [UIColor colorWithWhite:1 alpha:1];
    phoneTextField.textAlignment = NSTextAlignmentCenter;
    phoneTextField.font =fontBysize(16);
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1]}];
    
    [self.view addSubview:phoneTextField];
    
    
    UIView *bottomView1 = [[UIView alloc]init];
    bottomView1.backgroundColor = [UIColor customRedColor];
    [backImageView addSubview:bottomView1];
    bottomView1.sd_layout
    .leftSpaceToView(backImageView,80)
    .rightSpaceToView(backImageView,80)
    .topSpaceToView (phoneTextField, -5)
    .heightIs(2);
    
    
    passWordTextFied=[[UITextField alloc] initWithFrame:CGRectMake(40,210 + 100*forSmallScreen, SYSTEM_WIDTH-80, 50)];
    [passWordTextFied setKeyboardType:UIKeyboardTypeEmailAddress];
    [passWordTextFied setSecureTextEntry:YES];
    passWordTextFied.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1]}];
    [passWordTextFied setClearsOnBeginEditing:YES];
    passWordTextFied.delegate = self;
    passWordTextFied.textColor = [UIColor colorWithWhite:1 alpha:1];
    passWordTextFied.font =fontBysize(16);
    passWordTextFied.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passWordTextFied];

    UIView *bottomView2 = [[UIView alloc]init];
    bottomView2.backgroundColor = [UIColor customRedColor];
    [backImageView addSubview:bottomView2];
    bottomView2.sd_layout
    .leftSpaceToView(backImageView,80)
    .rightSpaceToView(backImageView,80)
    .topSpaceToView (passWordTextFied, -5)
    .heightIs(2);
    
    
    UIView *loginView = [[UIView alloc]init];
    loginView.backgroundColor = [UIColor customRedColor];
    [backImageView addSubview:loginView];
    loginView.clipsToBounds = YES;
    loginView.layer.cornerRadius = 33;
    
    loginView.sd_layout
    .widthIs(66)
    .heightIs(66)
    .centerXEqualToView(backImageView)
    .topSpaceToView(bottomView2,40);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginButtonClick)];
    [loginView addGestureRecognizer:tap];
    
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_arrow"]];
    [loginView addSubview:loginImageView];
    
    loginImageView.sd_layout
    .widthIs(18)
    .heightIs(18)
    .centerXEqualToView(loginView)
    .centerYEqualToView(loginView);
    
    
    backImageView.userInteractionEnabled = YES;
    loginImageView.userInteractionEnabled = YES;
    
    UIButton *forgetPassport = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassport setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPassport setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPassport addTarget:self action:@selector(resetPassWordClick) forControlEvents:UIControlEventTouchUpInside];
    forgetPassport.titleLabel.font = fontBysize(16);
    [backImageView addSubview:forgetPassport];
    
    
    forgetPassport.sd_layout
    .leftSpaceToView(backImageView,80)
    .rightSpaceToView(backImageView,80)
    .heightIs(20)
    .centerXEqualToView(backImageView)
    .bottomSpaceToView(backImageView,70*forSmallScreen);

    

    UIButton *creatAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [creatAccount setTitle:@"创建账户" forState:UIControlStateNormal];
    [creatAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creatAccount addTarget:self action:@selector(gotoRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    creatAccount.titleLabel.font = fontBysize(16);
    [backImageView addSubview:creatAccount];
    
    
    
    
    creatAccount.sd_layout
    .leftSpaceToView(backImageView,80)
    .rightSpaceToView(backImageView,80)
    .heightIs(20)
    .centerXEqualToView(backImageView)
    .bottomSpaceToView(forgetPassport,30);
    
}

#pragma mark --------> 登陆

- (void)loginButtonClick{
    
    if ([phoneTextField.text isEmpty]||![phoneTextField.text isValidateMobile]) {
        toast_showInfoMsg(@"手机号码不符合规范", 200);
        return;
    }
    if ([passWordTextFied.text isEmpty]||passWordTextFied.text.length<6) {
        toast_showInfoMsg(@"密码少于6位", 200);
        return;
    }
    [self diverLogin];
}
- (void)diverLogin{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:phoneTextField.text key:USERNAME];
    [parameters put:passWordTextFied.text key:PWD];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [[DiverHttpRequstManager requestManager] postWithRequestBodyString:SIGN_IN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"请求失败")];
        }else{
            NSDictionary *driver = [result objectForKey:@"driver"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            save_UserPwd(passWordTextFied.text);
            save_userPhone([driver stringForKey:@"username"]);
            save_PushId([driver stringForKey:USER_PUSH_ID]);
            save_AccessToken([result stringForKey:ACCESS_TOKEN]);
            [self pushToHomePage];
        }
    }];
    
}

#pragma mark ---------> 登陆成功 跳转到主页
- (void)pushToHomePage{
    HomePageViewController *homePage = [[HomePageViewController alloc]init];
    [self.navigationController pushViewController:homePage animated:YES];
}

#pragma mark ---------> 注册
- (void)gotoRegisterVC{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithRegisterType:REGISTER_TRUCK_MAN];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark ---------> 修改密码

- (void)resetPassWordClick{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithRegisterType:FORGET_USER_PASSWORD];
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma mark ---> 自动登录接口
- (void)autoLogin{//
    
    if (accessToken()&&![accessToken() isEmpty]&&user_phone()&&![user_phone() isEmpty]&&user_Pwd()&&![user_Pwd() isEmpty]) {
        
        _lauchImage  = [[UIImageView alloc]initWithFrame:self.view.frame];
        _lauchImage.image = [UIImage imageNamed:@"Default-667h@2x"];
        //适配3.5寸屏幕
        if (self.view.frame.size.height<=480) {
            _lauchImage.image = [UIImage imageNamed:@"Default"];
        }
        [[AppDelegate shareAppDelegate].window addSubview:_lauchImage];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hiddleImage) userInfo:nil repeats:NO];
        HomePageViewController *homePage = [[HomePageViewController alloc]init];
        [self.navigationController pushViewController:homePage animated:NO];
        
    }
}
- (void)hiddleImage{
    [[AppDelegate shareAppDelegate].window addSubview:_lauchImage];
    [UIView animateWithDuration:1 animations:^{
        _lauchImage.alpha = 0;
    } completion:^(BOOL finished) {
        [_lauchImage removeFromSuperview];
        _lauchImage = nil;
    }];
}

#pragma mark ---> 返回 其他
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
