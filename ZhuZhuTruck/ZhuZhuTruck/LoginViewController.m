//
//  LoginViewController.m
//  ZhengChe
//
//  Created by CongCong on 16/9/12.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    CCTextFiled *phoneTextField;
    CCTextFiled *passWordTextFied;
    UIButton *diverButton;
    UIButton *shipperButton;
    UIButton *reciverButton;
    
}
@property (nonatomic, weak) AppDelegate *appDeleted;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"登录"];
    self.fd_interactivePopDisabled = YES;
    self.appDeleted = [AppDelegate shareAppDelegate];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initAccoutView];
    [self initLoginView];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if(authorizationStatus == kCLAuthorizationStatusNotDetermined){
        [[LocationTracker defaultLoactionTarker] startLocationTracking];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenInvild) name:USER_TOKEN_INVILID_NOTI object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isAutoLogin) {
        [self autoLogin];
    }
}
- (void)initAccoutView{
    phoneTextField=[[CCTextFiled alloc] initWithFrame:CGRectMake(20,130,SYSTEM_WIDTH-40, 50)];
    [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    phoneTextField.delegate = self;
    [phoneTextField setText:user_phone()];
    phoneTextField.delegate = self;
    [phoneTextField setPlaceholder:@"请输入手机号"];
    [self.view addSubview:phoneTextField];
    [phoneTextField setText:user_phone()];
    
    passWordTextFied=[[CCTextFiled alloc] initWithFrame:CGRectMake(20,190, SYSTEM_WIDTH-40, 50)];
    [passWordTextFied setKeyboardType:UIKeyboardTypeEmailAddress];
    [passWordTextFied setSecureTextEntry:YES];
    [passWordTextFied setPlaceholder:@"请输入密码"];
    [passWordTextFied setClearsOnBeginEditing:YES];
    passWordTextFied.delegate = self;
//    [passWordTextFied setText:user_Pwd()];
    [self.view addSubview:passWordTextFied];
}
- (void)initLoginView{
    
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,SYSTEM_HEIGHT-150, SYSTEM_WIDTH-40, 50) cornerradius:CORNERRADIUS title:@"登   录" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(loginButtonClick)];
    [self.view addSubview:loginButton];
    
    UIButton *forgetPassWord = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassWord setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPassWord setTitleColor:[UIColor buttonGreenColor] forState:UIControlStateNormal];
    [forgetPassWord.titleLabel setFont:fontBysize(11)];
    [forgetPassWord setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [forgetPassWord addTarget:self action:@selector(resetPassWordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPassWord];
    
    UIButton *registerAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerAccount setTitle:@"还没账号 立即注册" forState:UIControlStateNormal];
    [registerAccount setTitleColor:[UIColor buttonGreenColor] forState:UIControlStateNormal];
    [registerAccount.titleLabel setFont:fontBysize(11)];
    [registerAccount setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [registerAccount addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerAccount];
    
    forgetPassWord.sd_layout
    .leftSpaceToView(self.view ,20)
    .bottomSpaceToView(loginButton,5)
    .widthIs(100)
    .heightIs(20);
    registerAccount.sd_layout
    .rightSpaceToView(self.view ,20)
    .bottomSpaceToView(loginButton,5)
    .widthIs(200)
    .heightIs(20);
    
//    UILabel* help=[[UILabel alloc] initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-30, SYSTEM_WIDTH, 20)];
//    [help setText:@"如有问题请拨打400-886-9256客服电话"];
//    [help setFont:fontBysize(10)];
//    [help setTextAlignment:NSTextAlignmentCenter];
//    UIColor *color =UIColorFromRGB(0x757575);
//    [help setTextColor:color];
//    [self.view addSubview:help];
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


- (void)tokenInvild{
    
    if ([accessToken() isEmpty]) {
        return;
    }
    save_UserPwd(@"");
    save_AccessToken(@"");
    [[DBManager sharedManager] deletedAllLocations];
    [[LocationTracker defaultLoactionTarker] stopLocationTracking];
    __weak typeof(self) _weakSelf = self;
    RIButtonItem *deleteItem = [RIButtonItem itemWithLabel:@"去登录" action:^{
        [_weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                        message:@"用户验证信息失效，请重新登录"
                                               cancelButtonItem:nil
                                               otherButtonItems:deleteItem, nil];
    [alertView show];
    
    
}

#pragma mark --------> 自动登陆
- (void)autoLogin{
    if (accessToken()&&![accessToken() isEmpty]&&user_phone()&&![user_phone() isEmpty]&&user_Pwd()&&![user_Pwd() isEmpty]) {
        HomePageViewController *homePage = [[HomePageViewController alloc]init];
        [self.navigationController pushViewController:homePage animated:NO];
    }
}

#pragma mark ---------> 登陆成功 跳转到主页
- (void)pushToHomePage{
//    [[NSNotificationCenter defaultCenter] postNotificationName:GET_JPUSH_REGISEDID_NOTI object:nil];
//    NSArray *viewControllers;
//    NSArray *titles;
//    NSString *title;
//    switch (_appDeleted.userRole) {
//            
//        case TRUCK_MAN:{
//            viewControllers = @[[DriverUnPickUpList class],[DriverTransitList class],[DriverCreatOrderByCode class]];
//            titles = @[@"未接单",@"已接单",@"创建运单"];
//            title = @"我的运单";
//        }
//            break;
//            
//        case CAR_SHIPPER:{
//            viewControllers = @[[ShipperReceiveCar class],[ShipperAssignCar class],[ShipperAssignedList class]];
//            titles = @[@"接收车辆",@"分配车辆",@"已分配"];
//            title = @"我的运单";
//        }
//            break;
//            
//        case RECEIVER_4S:{
//            viewControllers = @[[ReceiverCheckCar class],[RecevierCheckedList class]];
//            titles = @[@"待验收",@"已验收"];
//            title = @"验收车辆";
//        }
//            break;
//    }
    
//    HomePageViewController *pageVC = [[HomePageViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
//    pageVC.menuItemWidth = [UIScreen mainScreen].bounds.size.width/titles.count;
//    pageVC.postNotification = YES;
//    pageVC.bounces = YES;
//    pageVC.menuHeight = 36;
//    pageVC.menuViewStyle = WMMenuViewStyleLine;
//    pageVC.menuBGColor = [UIColor naviBarColor];
//    pageVC.titleColorSelected = [UIColor whiteColor];
//    pageVC.titleColorNormal = [UIColor colorWithWhite:0.9 alpha:0.8];
//    pageVC.titleFontName = @"Helvetica-Bold";
//    pageVC.titleSizeNormal = 18;
//    pageVC.progressHeight = 4;
//    pageVC.progressColor = [UIColor whiteColor];
//    pageVC.pageAnimatable = YES;
//    pageVC.titleSizeSelected = 18;
//    pageVC.title = title;
//
    HomePageViewController *homePage = [[HomePageViewController alloc]init];
    [self.navigationController pushViewController:homePage animated:YES];
}

- (void)resetPassWordClick{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithRegisterType:FORGET_USER_PASSWORD];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)registerAccount{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithRegisterType:REGISTER_TRUCK_MAN];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark ---> 返回 其他
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)naviBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
