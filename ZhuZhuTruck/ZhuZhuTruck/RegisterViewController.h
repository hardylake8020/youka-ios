//
//  RegisterViewController.h
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"
//注册 忘记密码
enum{
    REGISTER_TRUCK_MAN,
    FORGET_USER_PASSWORD
};
typedef NSInteger RegisterType;

@interface RegisterViewController : BaseViewController
- (instancetype)initWithRegisterType:(RegisterType)type;
@end
