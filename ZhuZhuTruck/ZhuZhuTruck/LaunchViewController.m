//
//  LaunchViewController.m
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <JPUSHService.h>
@interface LaunchViewController (){
    UIImageView *_lauchImage;
}

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:16]];
//    [[SeverTimeManager defaultManager] getServerTime];
    [[LocationUploadManager sharedManager] startUploadArray];
    
    self.title = @"启动页";
    [self initUI];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRegistedId) name:GET_JPUSH_REGISEDID_NOTI object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self autoLogin];
}
- (void)initUI{
    
    self.view.backgroundColor = UIColorFromRGB(0x4285f4);
    
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_backimg"]];
    [self.view addSubview:logoImage];
    
    logoImage.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .topSpaceToView(self.view,100)
    .autoHeightRatio(272/900.00);
    
    
    
    [self.view addSubview:logoImage];
    
    UIButton *registerButton = [CCButton ButtonWithFrame:CGRectMake(20,self.view.frame.size.height-160, self.view.frame.size.width-40, 50) cornerradius:CORNERRADIUS title:@"注册司机" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"ffb30f"] highLightImage:[UIImage imageNamed:@"D7960B"] target:self action:@selector(gotoRegisterVC)];
    [self.view addSubview:registerButton];
    
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,self.view.frame.size.height-90, self.view.frame.size.width-40, 50) cornerradius:CORNERRADIUS title:@"登录" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(gotoLoginVC)];
    [self.view addSubview:loginButton];
}


- (void)gotoRegisterVC{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithRegisterType:REGISTER_TRUCK_MAN];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)gotoLoginVC{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark ---> 自动登录接口
- (void)autoLogin{//
//    
//    [AppDelegate shareAppDelegate].userRole = user_type();
//    
//    if (accessToken()&&![accessToken() isEmpty]&&user_phone()&&![user_phone() isEmpty]&&user_Pwd()&&![user_Pwd() isEmpty]) {
//        
//        _lauchImage  = [[UIImageView alloc]initWithFrame:self.view.frame];
//        _lauchImage.image = [UIImage imageNamed:@"Default-568h@2x~iphone"];
//        //适配3.5寸屏幕
//        if (self.view.frame.size.height<=480) {
//            _lauchImage.image = [UIImage imageNamed:@"Default"];
//        }
//        [[AppDelegate shareAppDelegate].window addSubview:_lauchImage];
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hiddleImage) userInfo:nil repeats:NO];
//        LoginViewController *login = [[LoginViewController alloc]init];
//        login.isAutoLogin = YES;
//        [self.navigationController pushViewController:login animated:NO];
//    }
}
- (void)hiddleImage{
//    [[AppDelegate shareAppDelegate].window addSubview:_lauchImage];
//    [UIView animateWithDuration:1 animations:^{
//        _lauchImage.alpha = 0;
//    } completion:^(BOOL finished) {
//        [_lauchImage removeFromSuperview];
//        _lauchImage = nil;
//    }];
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
