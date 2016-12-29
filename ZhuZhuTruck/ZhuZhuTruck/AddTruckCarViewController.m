//
//  AddTruckCarViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/21.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AddTruckCarViewController.h"
#import "CarPhotoView.h"
#import "DOPDropDownMenu.h"
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface AddTruckCarViewController ()<UITextFieldDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *view_back;
    UITextField *_phoneNumberFiled;
    UITextField *_truckNumberFiled;
    UITextField *_driverNameFiled;
    UIPickerView *_truckTypePicker;
    CGFloat _topHight;
    NSString *_truckType;
    
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) DOPDropDownMenu *menu;
@property (nonatomic, strong) CarPhotoView *photoView;;
@property (nonatomic, copy  ) NSString *photoName;
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation AddTruckCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlackNaviHaderViewWithTitle:@"添加车辆"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    
    self.photoName = @"";
    
    self.dataArray = @[@"请选择车型",@"金杯车",@"4.2米",@"6.8米",@"7.6米",@"9.6前四后四",@"9.6前四后八",@"12.5米",@"14.7米",@"16.5米",@"17.5米"];
    
//    self.picker = [[UIImagePickerController alloc] init];
//    _picker.delegate = self;
//    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    view_back = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    view_back.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:view_back];
    
    [self initSeletCarTypeView];
    [self initAddTruckNumberView];
//    [self initAddDriverNameView];
    [self initAddPhoneView];
    
//    [self initAddPhotoView];
    
    [self initBottomButtonView];
}
- (void)initSeletCarTypeView{
    
    _truckType = @"";
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, SYSTITLEHEIGHT) andHeight:50];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    self.menu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.menu];

//    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, SYSTITLEHEIGHT, 100, 50)];
//    tipLabel.font = fontBysize(18);
//    tipLabel.text = @"车牌";
//    [self.view addSubview:tipLabel];
//    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, SYSTITLEHEIGHT, 1, 50)];
//    lineView.backgroundColor = [UIColor customGrayColor];
//    [self.view  addSubview:lineView];
    
}
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return self.dataArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return [self.dataArray objectAtIndex:indexPath.row];
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    NSString *type = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        _truckType = @"";
    }else{
        _truckType = type;
    }
}
- (void)initAddTruckNumberView{
    
    _topHight = 50;
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, _topHight, SYSTEM_WIDTH, 50)];
    [view_back addSubview:addView];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    tipLabel.font = fontBysize(16);
    tipLabel.text = @"车牌";
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 0.5, 50)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    _truckNumberFiled = [[UITextField alloc]initWithFrame:CGRectMake(140,0, SYSTEM_WIDTH-140, 50)];
    _truckNumberFiled.delegate = self;
    _truckNumberFiled.clearButtonMode = UITextFieldViewModeAlways;
    [_truckNumberFiled setPlaceholder:@"请输入车牌号"];
    _truckNumberFiled.font = fontBysize(16);
    [addView addSubview:_truckNumberFiled];
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView1];
}


- (void)initAddDriverNameView{
    
    _topHight+=50;
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, _topHight, SYSTEM_WIDTH, 50)];
    [view_back addSubview:addView];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    tipLabel.font = fontBysize(18);
    tipLabel.text = @"司机";
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 0.5, 50)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    _driverNameFiled = [[UITextField alloc]initWithFrame:CGRectMake(140,0, SYSTEM_WIDTH-140, 50)];
    _driverNameFiled.delegate = self;
    _driverNameFiled.clearButtonMode = UITextFieldViewModeAlways;
    [_driverNameFiled setPlaceholder:@"请输入司机姓名"];
    _driverNameFiled.font = fontBysize(16);
    [addView addSubview:_driverNameFiled];
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView1];
}


- (void)initAddPhoneView{
    
    _topHight+=50;
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, _topHight, SYSTEM_WIDTH, 50)];
    [view_back addSubview:addView];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    tipLabel.font = fontBysize(16);
    tipLabel.text = @"司机手机";
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 0.5, 50)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    _phoneNumberFiled = [[UITextField alloc]initWithFrame:CGRectMake(140,0, SYSTEM_WIDTH-140, 50)];
    _phoneNumberFiled.delegate = self;
    _phoneNumberFiled.clearButtonMode = UITextFieldViewModeAlways;
    _phoneNumberFiled.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNumberFiled setPlaceholder:@"请输入司机手机号"];
    _phoneNumberFiled.font = fontBysize(16);
    [addView addSubview:_phoneNumberFiled];
    
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView1];
}

- (void)initAddPhotoView{
    _topHight += 70;
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, _topHight, SYSTEM_WIDTH, 100)];
    addView.layer.borderColor = [UIColor customGrayColor].CGColor;
    addView.layer.borderWidth = 1;
    [view_back addSubview:addView];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 100)];
    tipLabel.font = fontBysize(16);
    tipLabel.text = @"车辆照片";
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 0.5, 100)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    self.photoView = [[CarPhotoView alloc]initWithFrame:CGRectMake(140, 5, 90, 90)];
    [_photoView setTitle:@"" andPhotoName:@""];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
    [_photoView addGestureRecognizer:tap];
    
    [addView addSubview:_photoView];
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView1];
}

- (void)takePhoto{
    
    
    if (![self.photoName isEmpty]||_photoName==nil) {
        CCWeakSelf(self);
        ShowPhotoViewController *show = [[ShowPhotoViewController alloc]initWithEditFileName:self.photoName editCallBack:^(NSString *fileName) {
            [[DBManager sharedManager] photoDeletedWithPhotoName:fileName];
            weakself.photoName = @"";
            [weakself.photoView setTitle:@"" andPhotoName:@""];
        }];
        
        [self.navigationController pushViewController:show animated:YES];
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"我知道了" action:^{}];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你拒绝了拍照权限,请你去设置->隐私->相机"
                                                            message:@"允许长安民生整车使用你的相机"
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:nil, nil];
        [alertView show];
        
    }else{
        [self presentViewController:_picker animated:YES completion:nil];
    }

}

#pragma mark ------> 照片回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%f%f",originalImage.size.width,originalImage.size.height);
    UIImage* image= scaleToSize([info objectForKey:UIImagePickerControllerOriginalImage],CGSizeMake(originalImage.size.width/2, originalImage.size.height/2));
    NSString* fileName=[NSString stringWithFormat:@"@ios_user_phone%@take_time%f", user_phone(),[[NSDate  date] timeIntervalSince1970]];
    if(saveImg(image,fileName)){
        [self.photoView setTitle:@"" andPhotoName:fileName];
        self.photoName = fileName;
        [[DBManager sharedManager] inserPhotoWithPhotoName:fileName orderId:@"" andStatus:0];
    }
    else
        toast_showInfoMsg(@"照片保存失败,请重试", 100);
}

- (void)initBottomButtonView{
    UIButton * addCadButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50)];
    addCadButton.backgroundColor = [UIColor buttonGreenColor];
    [addCadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [addCadButton setTitle:@"保存" forState:UIControlStateNormal];
    [addCadButton addTarget:self action:@selector(addCardCall) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addCadButton];
}

- (void)addCardCall{
    
    if (![_phoneNumberFiled.text isValidateMobile]) {
        toast_showInfoMsg(@"请填写正确的手机号", 200);
        return;
    }
    
    if (![_truckNumberFiled.text validateCarNo]) {
        toast_showInfoMsg(@"请填写正确的车牌号", 200);
        return;
    }
    
    if ([_truckType isEmpty]||_truckType == nil||[_truckType isEqualToString:@"请选择车型"]) {
        toast_showInfoMsg(@"请选择车型", 200);
        return;
    }
    
//    if ([_photoName isEmpty]||_photoName==nil) {
//        toast_showInfoMsg(@"请选拍摄一张照片", 200);
//        return;
//    }
    
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *truckInfo  = [NSMutableDictionary dictionary];
    
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [truckInfo put:_phoneNumberFiled.text key:@"driver_number"];
    
    [truckInfo put:[_truckNumberFiled.text uppercaseString] key:@"truck_number"];
    
    [truckInfo put:_truckType key:@"truck_type"];
    
    if ([_photoName isEmpty]||_photoName==nil) {
        [truckInfo put:_photoName key:@"truck_photo"];
    }
    
    if (![_driverNameFiled.text isEmpty]) {
        [truckInfo put:_driverNameFiled.text key:@"driver_name"];
    }
    
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
