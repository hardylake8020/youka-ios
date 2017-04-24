//
//  UserCertificationViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "UserCertificationViewController.h"
#import <Photos/Photos.h>
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UserCertificationViewController ()<UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, assign) BOOL isKeyBoradShow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TakePhotoModel *photoModel;
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation UserCertificationViewController

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
    
    TextFiledModel *textModel = [[TextFiledModel alloc]initWithTitle:@"账号" text:user_phone() andKey:USER_PHONE_NUMBER];
    textModel.isTitle = YES;
    [self.dataArray addObject:textModel];
    textModel = [[TextFiledModel alloc]initWithTitle:@"姓名" text:user_NickName() andKey:USER_NICK_NAME];
    textModel.placeHolder = @"请输入你的姓名";
    [self.dataArray addObject:textModel];
    TakePhotoModel *photoModel =[[TakePhotoModel alloc]initWithTitle:@"司机照片" photoName:user_headPhoto() andKey:USER_HEAD_PHOTO];
    [self.dataArray addObject:photoModel];
    
    textModel = [[TextFiledModel alloc]initWithTitle:@"身份证号" text:user_identiyCard() andKey:USER_IDENTIY_CARD];
    textModel.placeHolder = @"请输入你的身份证";
    [self.dataArray addObject:textModel];
    
    photoModel = [[TakePhotoModel alloc]initWithTitle:@"身份证照片" photoName:user_idCardPhoto() andKey:UER_ID_CARD_PHOTO];
    [self.dataArray addObject:photoModel];
    photoModel = [[TakePhotoModel alloc]initWithTitle:@"驾驶证照片" photoName:user_driverLicensePhoto() andKey:UER_DRIVING_LICENSE_PHOTO];
    [self.dataArray addObject:photoModel];
    
    self.picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
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
