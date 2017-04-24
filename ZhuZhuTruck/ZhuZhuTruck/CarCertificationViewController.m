//
//  CarCertificationViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CarCertificationViewController.h"
#import <Photos/Photos.h>
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <RMPickerViewController.h>
@interface CarCertificationViewController ()<UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) BOOL isKeyBoradShow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TakePhotoModel *photoModel;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSArray *carTypes;
@end

@implementation CarCertificationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.isKeyBoradShow = YES;
    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int keyboardHeight = keyboardRect.size.height;
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.isKeyBoradShow = NO;;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)initData{
    
    TextFiledModel *textModel = [[TextFiledModel alloc]initWithTitle:@"车牌号码" text:user_truckNumber() andKey:UER_TRUCK_NUMBER];
    textModel.placeHolder = @"请输入车牌号码";
    [self.dataArray addObject:textModel];
    textModel = [[TextFiledModel alloc]initWithTitle:@"车辆类型" text:user_truckType() andKey:UER_TRUCK_TYPE];
    textModel.placeHolder = @"请选择你的车辆类型";
    textModel.isTitle = YES;
    [self.dataArray addObject:textModel];
    TakePhotoModel *photoModel =[[TakePhotoModel alloc]initWithTitle:@"车辆照片" photoName:user_truckPhoto() andKey:UER_TRUCK_PHOTO];
    [self.dataArray addObject:photoModel];
    photoModel = [[TakePhotoModel alloc]initWithTitle:@"车牌近照" photoName:user_platePhoto() andKey:UER_PLATE_PHOTO];
    [self.dataArray addObject:photoModel];
    photoModel =[[TakePhotoModel alloc]initWithTitle:@"行驶证照" photoName:user_vehicleLicensePhoto() andKey:UER_VEIHCLEL_LICENDE_PHOTO];
    [self.dataArray addObject:photoModel];
    
    self.picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    
    self.carTypes =  @[@"金杯车",@"4.2米",@"6.8米",@"7.6米",@"9.6前四后四",@"9.6前四后八",@"12.5米",@"14.7米",@"16.5米",@"17.5米"];
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-150) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TakePhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFiledCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextFiledCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor customGrayColor];
    [self.view addSubview:self.tableView];
    
}

#pragma mark ---> UITableViewDelegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[TextFiledModel class]]) {
        return 50;
    }else{
        return 100;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[TextFiledModel class]]) {
        TextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledCell" forIndexPath:indexPath];
        [cell showTextFileCellWithModel:model];
        return cell;
    }else{
        TakePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakePhotoCell" forIndexPath:indexPath];
        [cell showPhotoCellWithModel:model];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.isKeyBoradShow) {
        [self.view endEditing:YES];
        return;
    }
    if ([model isKindOfClass:[TakePhotoModel class]]) {
        TakePhotoModel *photoModel = (TakePhotoModel *)model;
        if (photoModel.photoName&&![photoModel.photoName isEmpty]) {
            __weak typeof(self) _weakSelf = self;
            ShowPhotoViewController *show = [[ShowPhotoViewController alloc]initWithEditFileName:photoModel.photoName editCallBack:^(NSString *fileName) {
                [[DBManager sharedManager] photoDeletedWithPhotoName:fileName];
                photoModel.photoName = @"";
                [_weakSelf.tableView reloadData];
            }];
            [self.navigationController pushViewController:show animated:YES];
        }else{
            self.photoModel = photoModel;
            [self seletdPhotoSource];
        }
    }else{
        if (indexPath.row!=0) {
            [self showPickView:model];
        }
    }
}
- (void)seletdPhotoSource{
    NSArray *reasonArray = @[@"拍照",@"从手机相册选择"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:reasonArray actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex < reasonArray.count) {
            if (buttonIndex==0) {
                [self takePhoto];
            }else{
                [self seletPicture];
            }
        }
    }];
    [actionSheet show];
}

- (void)takePhoto{
    
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
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:nil];
    }
}

- (void)seletPicture{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"我知道了" action:^{}];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你拒绝了相册权限,请你去设置->隐私->照片"
                                                            message:@"允许长安民生整车使用你的照片"
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:nil, nil];
        [alertView show];
        
    }else{
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        self.photoModel.photoName = fileName;
        [[DBManager sharedManager] inserPhotoWithPhotoName:fileName orderId:@"xxxxxx" andStatus:HalfWayEvent];
        [self.tableView reloadData];
    }
    else
        toast_showInfoMsg(@"照片保存失败,请重试", 100);
}

- (void)showPickView:(TextFiledModel*)model{
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    style = RMActionControllerStyleWhite;
    CCWeakSelf(self);
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[controller.contentView numberOfComponents] ; i++) {
            [selectedRows addObject:@([controller.contentView selectedRowInComponent:i])];
        }
        model.text = [weakself.carTypes objectAtIndex:[selectedRows.firstObject intValue]];
        [weakself.tableView reloadData];
        model.isChange = YES;
        CCLog(@"Successfully selected rows: %@", selectedRows);
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
        CCLog(@"Row selection was canceled");
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:style];
    pickerController.title = @"请选择车型";
//    pickerController.message = @"This is a test message.\nPlease choose a row and press 'Select' or 'Cancel'.";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];

}


#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  self.carTypes.count;
}
#pragma Mark -- UIPickerViewDelegate
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.carTypes objectAtIndex:row];
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CCLog(@"选择了第%ld行",row);
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
