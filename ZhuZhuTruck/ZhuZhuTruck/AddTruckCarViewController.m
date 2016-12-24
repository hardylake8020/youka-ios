//
//  AddTruckCarViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/21.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AddTruckCarViewController.h"

@interface AddTruckCarViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    CCTextFiled *_phoneNumberFiled;
    CCTextFiled *_truckNumberFiled;
    UIPickerView *_truckTypePicker;
    
}
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation AddTruckCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"添加车辆"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initAddView];
}
- (void)initAddView{
    
    _phoneNumberFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,SYSTITLEHEIGHT+30, SYSTEM_WIDTH-40, 40)];
    [_phoneNumberFiled setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumberFiled.delegate = self;
    [_phoneNumberFiled setPlaceholder:@"请输入司机手机号"];
    _phoneNumberFiled.delegate = self;
    [self.view addSubview:_phoneNumberFiled];
    
    
    _truckNumberFiled = [[CCTextFiled alloc]initWithFrame:CGRectMake(20,SYSTITLEHEIGHT+90, SYSTEM_WIDTH-40, 40)];
    _truckNumberFiled.delegate = self;
    [_truckNumberFiled setPlaceholder:@"请输入车牌号"];
    _truckNumberFiled.delegate = self;
    [self.view addSubview:_truckNumberFiled];
//    '金杯车', '4.2米', '6.8米', '7.6米', '9.6前四后四', '9.6前四后八', '12.5米', '14.7米', '16.5米', '17.5米'
    
    self.dataArray = @[@"请选择车型⬇️",@"金杯车",@"4.2米",@"6.8米",@"7.6米",@"9.6前四后四",@"9.6前四后八",@"12.5米",@"14.7米",@"16.5米",@"17.5米"];
    
    _truckTypePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(20, SYSTITLEHEIGHT+150, SYSTEM_WIDTH-40, 120)];
    _truckTypePicker.delegate = self;
    _truckTypePicker.dataSource = self;
    _truckTypePicker.clipsToBounds = YES;
    _truckTypePicker.layer.cornerRadius = CORNERRADIUS;
    _truckTypePicker.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:_truckTypePicker];
    
//    [_truckTypePicker selectRow:1 inComponent:0 animated:NO];
    
    UIButton *loginButton = [CCButton ButtonWithFrame:CGRectMake(20,SYSTEM_HEIGHT-100, SYSTEM_WIDTH-40, 50) cornerradius:CORNERRADIUS title:@"添加" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(addCardCall)];
    [self.view addSubview:loginButton];
    
}


#pragma mark UIPickerView Deleagate dataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *truckType = [self.dataArray objectAtIndex:row];
    NSAttributedString *attributeSting = [[NSAttributedString alloc]initWithString:truckType];
    return attributeSting;
}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSString *truckType = [self.dataArray objectAtIndex:row];
//    self.tuckTypeIndex = row;
//    NSLog(@"----->%@",truckType);
//}


- (void)addCardCall{
    
    if (![_phoneNumberFiled.text isValidateMobile]) {
        toast_showInfoMsg(@"请填写正确的手机号", 200);
        return;
    }
    
    if (![_truckNumberFiled.text validateCarNo]) {
        toast_showInfoMsg(@"请填写正确的车牌号", 200);
        return;
    }
    
    if ([_truckTypePicker selectedRowInComponent:0]<1) {
        toast_showInfoMsg(@"请选择车型", 200);
        return;
    }
    
    NSString *truckType = [self.dataArray objectAtIndex:[_truckTypePicker selectedRowInComponent:0]];
    
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *truckInfo  = [NSMutableDictionary dictionary];
    
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [truckInfo put:_phoneNumberFiled.text key:@"driver_number"];
    
    [truckInfo put:[_truckNumberFiled.text uppercaseString] key:@"truck_number"];
    
    [truckInfo put:truckType key:@"truck_type"];
    
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
