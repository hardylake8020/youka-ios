//
//  PersonInfoViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/3.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "NSString+FontAwesome.h"
#import "PersonInfoCell.h"
#import "AddPhotoViewController.h"
#import "AddTextFiledViewController.h"
#import "AddTruckTypeViewController.h"
@interface PersonInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"个人信息"];
    
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}



- (void)initTableView{
    
    self.dataArray = [NSMutableArray array];

//    NSMutableDictionary *personInfoDict = [NSMutableDictionary dictionary];
    NSMutableArray *firstSectionArray = [NSMutableArray array];
    PersonInfoModel *model = [[PersonInfoModel alloc]initWithTitle:@"身份证照片" photoName:user_idCardPhoto() andKey:UER_ID_CARD_PHOTO];
    
    
//    [personInfoDict put:@"身份证照片" key:@"title"];
//    [personInfoDict put:user_idCardPhoto() key:@"photoname"];
//    [personInfoDict put:UER_ID_CARD_PHOTO key:@"key"];
    
    [firstSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"银行卡照片" key:@"title"];
//    [personInfoDict put:user_bankCardPhoto() key:@"photoname"];
//    [personInfoDict put:UER_BANK_CARD_PHOTO key:@"key"];
//    [firstSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"银行卡照片" photoName:user_bankCardPhoto() andKey:UER_BANK_CARD_PHOTO];
    [firstSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"驾驶证照片" key:@"title"];
//    [personInfoDict put:user_driverLicensePhoto() key:@"photoname"];
//    [personInfoDict put:UER_DRIVING_LICENSE_PHOTO key:@"key"];
//    [firstSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"驾驶证照片" photoName:user_driverLicensePhoto() andKey:UER_DRIVING_LICENSE_PHOTO];
    [firstSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"行驶证照片" key:@"title"];
//    [personInfoDict put:user_vehicleLicensePhoto() key:@"photoname"];
//    [personInfoDict put:UER_VEIHCLEL_LICENDE_PHOTO key:@"key"];
//    [firstSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"行驶证照片" photoName:user_vehicleLicensePhoto() andKey:UER_VEIHCLEL_LICENDE_PHOTO];
    [firstSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"装车单照片" key:@"title"];
//    [personInfoDict put:user_truckListPhoto() key:@"photoname"];
//    [personInfoDict put:UER_TRUCK_LIST_PHOTO key:@"key"];
//    [firstSectionArray addObject:personInfoDict];
    
    model = [[PersonInfoModel alloc]initWithTitle:@"装车单照片" photoName:user_truckListPhoto() andKey:UER_TRUCK_LIST_PHOTO];
    [firstSectionArray addObject:model];
    
    [self.dataArray addObject:firstSectionArray];
    
    NSMutableArray *secondSectionArray = [NSMutableArray array];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"车辆照片" key:@"title"];
//    [personInfoDict put:user_truckPhoto() key:@"photoname"];
//    [personInfoDict put:UER_TRUCK_PHOTO key:@"key"];
//    [secondSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"车辆照片" photoName:user_truckPhoto() andKey:UER_TRUCK_PHOTO];
    [secondSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"车牌号照片" key:@"title"];
//    [personInfoDict put:user_platePhoto() key:@"photoname"];
//    [personInfoDict put:UER_PLATE_PHOTO key:@"key"];
//    [secondSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"车牌号照片" photoName:user_platePhoto() andKey:UER_PLATE_PHOTO];
    [secondSectionArray addObject:model];
    
    [self.dataArray addObject:secondSectionArray];
    
    NSMutableArray *thirdSectionArray = [NSMutableArray array];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"车辆类型" key:@"title"];
//    [personInfoDict put:user_truckType() key:@"photoname"];
//    [personInfoDict put:UER_TRUCK_TYPE key:@"key"];
//    [thirdSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"车辆类型" photoName:user_truckType() andKey:UER_TRUCK_TYPE];
    [thirdSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"车牌号" key:@"title"];
//    [personInfoDict put:user_truckNumber() key:@"photoname"];
//    [personInfoDict put:UER_TRUCK_NUMBER key:@"key"];
//    [thirdSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"车牌号" photoName:user_truckNumber() andKey:UER_TRUCK_NUMBER];
    [thirdSectionArray addObject:model];
    
//    personInfoDict = [NSMutableDictionary dictionary];
//    [personInfoDict put:@"用户名称" key:@"title"];
//    [personInfoDict put:user_NickName() key:@"photoname"];
//    [personInfoDict put:USER_NICK_NAME key:@"key"];
//    [thirdSectionArray addObject:personInfoDict];

    model = [[PersonInfoModel alloc]initWithTitle:@"用户名称" photoName:user_NickName() andKey:USER_NICK_NAME];
    [thirdSectionArray addObject:model];
    
    [self.dataArray addObject:thirdSectionArray];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-50) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor customGrayColor]];
    [self.view addSubview:self.tableView];
    
    UIButton *saveButton = [CCButton ButtonWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50) cornerradius:0 title:@"保存修改" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(saveUserInfo)];
    [self.view addSubview:saveButton];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *titles = [self.dataArray objectAtIndex:section];
    return titles.count;
}
- (PersonInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell" forIndexPath:indexPath];
    NSArray *photoModels = [self.dataArray objectAtIndex:indexPath.section];
    [cell showCellWithPerInfoModel:[photoModels objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *photoModels = [self.dataArray objectAtIndex:indexPath.section];
    
    PersonInfoModel *model = [photoModels objectAtIndex:indexPath.row];
    CCWeakSelf(self);
    
    if (indexPath.section==2) {
        if (indexPath.row) {
            AddTextFiledViewController *addText = [[AddTextFiledViewController alloc]initWithInfoModel:model andCallBack:^(NSString *textString) {
                if (![textString isEqualToString:model.photoName]) {
                    model.isChange = YES;
                }
                model.photoName = textString;
                [weakself.tableView reloadData];
            }];
            [self.navigationController pushViewController:addText animated:YES];
        }else{
            AddTruckTypeViewController *addTruckType = [[AddTruckTypeViewController alloc]initWithInfoModel:model andCallback:^(NSString *truckType) {
                if (![truckType isEqualToString:model.photoName]) {
                    model.isChange = YES;
                }
                model.photoName = truckType;
                
                [weakself.tableView reloadData];

            }];
            [self.navigationController pushViewController:addTruckType animated:YES];
        }
        
    }else{
        AddPhotoViewController *addPhoto = [[AddPhotoViewController alloc]initWithPersonInfoModel:model andAddCallBack:^(NSString *photoName) {
            
            if (![photoName isEqualToString:model.photoName]) {
                model.isChange = YES;
            }
            
            model.photoName = photoName;
            
            [weakself.tableView reloadData];
        }];
        [self.navigationController pushViewController:addPhoto animated:YES];
    }
    
    
}

- (void)saveUserInfo{
    
    __weak typeof(self) _weakSelf = self;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    for (NSArray *personInfoModels in self.dataArray) {
        for (PersonInfoModel *model in personInfoModels) {
            [parameters put:model.photoName key:model.key];
        }
    }
    
    [SVProgressHUD showWithStatus:@"正在保存中"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:UPDATE_USER_INFO parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"保存失败")];
        }else{
            NSDictionary *driver = [result objectForKey:@"driver"];
            save_userProfiles(driver);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [_weakSelf naviBack];
        }
    }];
}



//- (void)initPersonInfoView{
//    
//    CGFloat height = SYSTITLEHEIGHT + 20;
//    
//    UILabel *idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,height, SYSTEM_WIDTH-40, 40)];
//    idCardLabel.text = @"身份证";
//    idCardLabel.textAlignment = NSTextAlignmentCenter;
//    idCardLabel.font = fontBysize(16);
//    
//    [self.view addSubview:idCardLabel];
//
//    height +=40;
//    
//    _idCardTextFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, SYSTEM_WIDTH-40, 40)];
//    [_idCardTextFiled setKeyboardType:UIKeyboardTypeASCIICapable];
//    _idCardTextFiled.delegate = self;
//    
//    [_idCardTextFiled setPlaceholder:@"请输入身份证号"];
//    _idCardTextFiled.text = user_identiyCard();
//    [self.view addSubview:_idCardTextFiled];
//
//    
//    height +=60;
//    
//    UILabel *backCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,height, SYSTEM_WIDTH-40, 40)];
//    backCardLabel.text = @"银行卡";
//    backCardLabel.textAlignment = NSTextAlignmentCenter;
//    backCardLabel.font = fontBysize(16);
//    [self.view addSubview:backCardLabel];
//    
//    
//    height +=40;
//    
//    _bankCardTextFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,height, SYSTEM_WIDTH-40, 40)];
//    [_bankCardTextFiled setKeyboardType:UIKeyboardTypeNumberPad];
//    _bankCardTextFiled.delegate = self;
//    [_bankCardTextFiled setPlaceholder:@"请输入银行卡号"];
//    _bankCardTextFiled.text = user_bankCard();
//    [self.view addSubview:_bankCardTextFiled];
//    
//    
//    UIButton *saveButton = [CCButton ButtonWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50) cornerradius:0 title:@"保存修改" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(saveUserInfo)];
//    [self.view addSubview:saveButton];
//}
//
//- (void)saveUserInfo{
//    
//    
//    if ([_bankCardTextFiled.text isEmpty]||[_idCardTextFiled.text isEmpty]) {
//        toast_showInfoMsg(@"请填写完整信息", 200);
//        return;
//    }
//    
//    if (![_idCardTextFiled.text isValidIdentityCard]) {
//        toast_showInfoMsg(@"请输入正确的身份证号", 200);
//        return;
//    }
//    
//    if (![_bankCardTextFiled.text isValidBankCard]) {
//        toast_showInfoMsg(@"请输入正确的银行卡号", 200);
//        return;
//    }
//    
//    __weak typeof(self) _weakSelf = self;
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters put:_idCardTextFiled.text key:USER_IDENTIY_CARD];
//    [parameters put:_bankCardTextFiled.text key:USER_BANK_CARD];
//    [parameters put:accessToken() key:ACCESS_TOKEN];
//    
//    [SVProgressHUD showWithStatus:@"正在保存中"];
//    [[HttpRequstManager requestManager] postWithRequestBodyString:UPDATE_USER_INFO parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"保存失败")];
//        }else{
//            
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//            save_identiyCard(_idCardTextFiled.text);
//            save_bankCard(_bankCardTextFiled.text);
//            [_weakSelf naviBack];
//        }
//    }];
//    
//    
//}
//
//#pragma mark ---> 返回 其他
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}

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
