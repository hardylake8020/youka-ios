//
//  InfomatationCertificationPages.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "InfomatationCertificationPages.h"
#import "CCAlert.h"
#import "Constants.h"
#import "CCUserData.h"
#import <SVProgressHUD.h>
#import "CCNaviHeaderView.h"
#import "HttpRequstManager.h"
#import "UIColor+CustomColors.h"
#import "NSMutableDictionary+Tool.h"
#import "CarCertificationViewController.h"
#import "UserCertificationViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface InfomatationCertificationPages ()

@end

@implementation InfomatationCertificationPages

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    [self initBottomView];
}


- (void)initBottomView{
    UIButton * sumbitButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50)];
    sumbitButton.backgroundColor = [UIColor buttonGreenColor];
    [sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sumbitButton setTitle:@"保存修改" forState:UIControlStateNormal];
    [sumbitButton addTarget:self action:@selector(saveCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitButton];
}


- (void)saveCall{
//    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    
    if (self.subViewControllers.count>0) {
        UserCertificationViewController *userVC = [self.subViewControllers objectAtIndex:0];
        if (userVC) {
            for (id model in userVC.dataArray) {
                if ([model isKindOfClass:[TakePhotoModel class]]) {
                    TakePhotoModel *photoModel = (TakePhotoModel *)model;
                    [parameters put:photoModel.photoName key:photoModel.key];
                }else{
                    TextFiledModel *textModel = (TextFiledModel *)model;
                    if ([textModel.title isEqualToString:@"身份证号"]&&
                        ![textModel.text isEmpty]&&![textModel.text isValidIdentityCard]) {
                        toast_showInfoMsg(@"身份证格式不正确，请重新填写", 200);
                        return;
                    }
                    [parameters put:textModel.text key:textModel.key];
                }
                
            }
        }
    }
    
    if (self.subViewControllers.count>1 ) {
        CarCertificationViewController *carVC = [self.subViewControllers objectAtIndex:1];
        if (carVC) {
            for (id model in carVC.dataArray) {
                if ([model isKindOfClass:[TakePhotoModel class]]) {
                    TakePhotoModel *photoModel = (TakePhotoModel *)model;
                    [parameters put:photoModel.photoName key:photoModel.key];
                }else{
                    TextFiledModel *textModel = (TextFiledModel *)model;
                    if ([textModel.title isEqualToString:@"车牌号码"]&&
                        ![textModel.text isEmpty]&&![textModel.text validateCarNo]) {
                        toast_showInfoMsg(@"车牌格式不正确，请重新填写", 200);
                        return;
                    }
                    [parameters put:[textModel.text uppercaseString] key:textModel.key];
                }
            }
        }
    }
    
    CCWeakSelf(self);
    [SVProgressHUD showWithStatus:@"正在保存中"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:UPDATE_USER_INFO parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"保存失败")];
        }else{
            NSDictionary *driver = [result objectForKey:@"driver"];
            save_userProfiles(driver);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [weakself naviBack];
        }
    }];
}

- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
