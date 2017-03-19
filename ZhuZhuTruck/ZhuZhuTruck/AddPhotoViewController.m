//
//  AddPhotoViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/16.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "PictureCell.h"
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface AddPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSMutableDictionary *photoDict;
@property (nonatomic, strong) PersonInfoModel *personModel;
@property (nonatomic, copy)   AddPhotoCallBack callHandler;
@end

@implementation AddPhotoViewController

- (instancetype)initWithPhotoDict:(NSMutableDictionary *)dict andAddCallBack:(AddPhotoCallBack )callBack
{
    self = [super init];
    if (self) {
        self.photoDict = dict;
        self.callHandler = callBack;
    }
    return self;
}

- (instancetype)initWithPersonInfoModel:(PersonInfoModel *)model andAddCallBack:(AddPhotoCallBack)callBack{
    self = [super init];
    if (self) {
        self.personModel = model;
        self.callHandler = callBack;
    }
    return self;
}


- (NSMutableArray *)photos{
    if(!_photos){
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"添加照片";
    NSString *photoname = self.personModel.photoName;
    
    if (![photoname isEmpty]) {
        [self.photos addObject:photoname];
    }
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [addButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naivHeader addRightButton:addButton];
    
    
    [self initTool];
    [self initPhotoWall];

}

- (void)initTool{
    
    self.picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    
}

- (void)initPhotoWall{

    MarginLabel *titleLabel = [[MarginLabel alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+20, SYSTEM_WIDTH, 40) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    titleLabel.text = [NSString stringWithFormat:@"请拍摄%@",self.personModel.title];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SYSTITLEHEIGHT+60, SYSTEM_WIDTH, SYSTEM_WIDTH/3+20) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:@"PictureCell"];
    
    [self.view addSubview:self.collectionView];
    
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"PictureCell";
    PictureCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[PictureCell alloc]init];
    }
    if (indexPath.row == self.photos.count) {
        [cell setPhotoName:@""];
    }else{
        [cell setPhotoName:self.photos[indexPath.row]];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.photos.count) {
        [self seletdPhotoSource];
    }else{
        
        NSString *fileName = _photos[indexPath.row];
        __weak typeof(self) _weakSelf = self;
        ShowPhotoViewController *show = [[ShowPhotoViewController alloc]initWithEditFileName:fileName editCallBack:^(NSString *fileName) {
            [[DBManager sharedManager] photoDeletedWithPhotoName:fileName];
            
            [_weakSelf.photos removeObject:fileName];
        
            [_weakSelf.collectionView reloadData];
        }];
        
        [self.navigationController pushViewController:show animated:YES];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout


//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int Wight = (self.view.frame.size.width-40)/3;
    return CGSizeMake(Wight,Wight);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
        [self.photos addObject:fileName];
        [[DBManager sharedManager] inserPhotoWithPhotoName:fileName orderId:@"xxxxxx" andStatus:HalfWayEvent];
        [self.collectionView reloadData];
    }
    else
        toast_showInfoMsg(@"照片保存失败,请重试", 100);
}

- (void)savePhoto{
    if (self.photos.count==0) {
        toast_showInfoMsg(@"请拍摄照片", 200);
        return;
    }
    if (self.callHandler) {
        if (self.photos.count>0) {
            self.callHandler([self.photos firstObject]);
        }else{
            self.callHandler(@"");
        }
    }
    [self naviBack];
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
