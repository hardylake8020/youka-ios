//
//  DriverOperationViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriverOperationViewController.h"
#import "LVRecordTool.h"
#import "RecordImageView.h"
#import "ShowPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DriverOperationViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,LVRecordToolDelegate>
{
    CCTextFiled *_markTextView;
    UIButton *_markVioceButton;
    UIButton *_playButton;
    RecordImageView *_voiceView;
    NSString *_voiceName;
    AddressManager *_addressManager;
}
@property (nonatomic, assign) DriverOperationType operationType;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIView *reportReasonView;
@property (nonatomic, strong) LVRecordTool *recordTool;
@property (nonatomic, assign) BOOL isRecordSucceed;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

@end

@implementation DriverOperationViewController

- (instancetype)initWithDriverOperationType:(DriverOperationType)type
{
    self = [super init];
    if (self) {
        self.operationType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorFromRGB(0xe5e5e5);
    self.fd_interactivePopDisabled = YES;
    
    switch (self.operationType) {
        case PickupSign:
        {
            [self addNaviHeaderViewWithTitle:@"提货进场"];
        }
            break;
        case PickupSucceed:
        {
            [self addNaviHeaderViewWithTitle:@"提货成功"];
        }
            break;
        case DeliveySign:
        {
            [self addNaviHeaderViewWithTitle:@"交货进场"];
        }
            break;
        case DeliveySucceed:
        {
            [self addNaviHeaderViewWithTitle:@"交货成功"];
        }
            break;
        case HalfWayEvent:
        {
            [self addNaviHeaderViewWithTitle:@"中途事件"];
        }
            break;
    }
    
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initTool];
    [self initData];
    [self initPhotoWall];
    [self initReportReasonView];
    [self initSumbitView];
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
- (void)initData{
    _voiceName = @"";
    self.photos = [NSMutableArray array];
}
- (void)initTool{
    self.picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.recordTool = [LVRecordTool sharedRecordTool];
    _recordTool.delegate = self;
    [self.recordTool playRecordingFile];//预热
    [self getAddress];
}
- (void)getAddress{
    _addressManager = [AddressManager sharedManager];
    CCWeakSelf(self);
    [_addressManager getCurentAddressWithCallBackHandler:^(NSString *address, CLLocationCoordinate2D location) {
        weakself.address = address;
        weakself.userLocation = location;
    }];
}
- (void)initPhotoWall{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT-250) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    //注册Cell，必须要有
    [self.collectionView registerClass:[PhotosCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count+1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    PhotosCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[PhotosCell alloc]init];
    }
    if (indexPath.row == self.photos.count) {
        [cell setTitle:@"拍照（可选）" andPhotoName:@""];
    }else{
        [cell setTitle:@"拍照（可选）" andPhotoName:self.photos[indexPath.row]];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.photos.count) {
        [self takePhoto];
    }else{
        NSString *fileName = _photos[indexPath.row];
        __weak typeof(self) _weakSelf = self;
        ShowPhotoViewController *show = [[ShowPhotoViewController alloc]initWithEditFileName:fileName editCallBack:^(NSString *fileName) {
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
    NSString* fileName=[NSString stringWithFormat:@"ios_user_phone%@take_time%@", user_phone(),[NSDate  date]];
    if(saveImg(image,fileName)){
        [self.photos addObject:fileName];
        [self.collectionView reloadData];
    }
    else
        toast_showInfoMsg(@"照片保存失败,请重试", 100);
}

#pragma mark -------> 填写原因和备注
- (void)initReportReasonView{
    
    self.reportReasonView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-150, SYSTEM_WIDTH, 100)];
    self.reportReasonView.backgroundColor = [UIColor clearColor];
    MarginLabel *choiceTipLabel = [[MarginLabel alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 40) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    choiceTipLabel.backgroundColor = ColorFromRGB(0xf5f5f5);
    choiceTipLabel.font = fontBysize(18);
    choiceTipLabel.text = @"录音或备注";
    choiceTipLabel.textColor = UIColorFromRGB(0x999999);
    [_reportReasonView addSubview:choiceTipLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = ColorFromRGB(0xdddddd);
    [_reportReasonView addSubview:line];
    
    line.sd_layout
    .heightIs(0.5)
    .leftEqualToView (_reportReasonView)
    .rightEqualToView(_reportReasonView)
    .topSpaceToView(_reportReasonView,0);
    
#pragma mark -------> 录音备注
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markButton setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [markButton setBackgroundImage:[UIImage imageNamed:@"text"] forState:UIControlStateSelected];
    [_reportReasonView addSubview:markButton];
    
    [markButton addTarget:self action:@selector(markChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    markButton.sd_layout
    .leftSpaceToView (_reportReasonView,15)
    .bottomSpaceToView(_reportReasonView,7.5)
    .heightIs(45)
    .widthIs(45);
    
    _markTextView = [[CCTextFiled alloc]init];
    _markTextView.delegate = self;
    _markTextView.placeholder = @"请添加备注";
    [_reportReasonView addSubview:_markTextView];
    
    _markTextView.sd_layout
    .leftSpaceToView(markButton,20)
    .rightSpaceToView (_reportReasonView,20)
    .bottomSpaceToView (_reportReasonView,7.5)
    .heightIs(45);
    
    _markVioceButton = [CCButton ButtonCornerradius:CORNERRADIUS title:@"长按 录音" titleColor:[UIColor blackColor] titleSeletedColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:18] normalBackGrondImage:[UIImage imageNamed:@"f7f7f7"]  seletedImage:nil target:nil action:nil];
    [_markVioceButton setBackgroundImage:[UIImage imageNamed:@"7f7f7f"] forState:UIControlStateHighlighted];
    [_markVioceButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [_reportReasonView addSubview:_markVioceButton];
    _markVioceButton.sd_layout
    .leftSpaceToView(markButton,20)
    .rightSpaceToView (_reportReasonView,80)
    .bottomSpaceToView (_reportReasonView,7.5)
    .heightIs(45);
    _markVioceButton.hidden = YES;
    // 录音按钮
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.view addSubview:self.reportReasonView];
    
    _voiceView = [[RecordImageView alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/2-75,250, 150, 150)];
    [self.view addSubview:_voiceView];
    _voiceView.hidden = YES;
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [_reportReasonView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
    _playButton.sd_layout
    .rightSpaceToView (_reportReasonView,15)
    .bottomSpaceToView(_reportReasonView,7.5)
    .heightIs(45)
    .widthIs(45);
}

#pragma mark - 录音按钮事件
- (void)recordBtnDidTouchRepeat:(UIButton *)recordBtn{
    if ([self.recordTool.recorder isRecording]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self lockVoiceButton];
                toast_showInfoMsg(@"已取消录音", 200);
            });
        });
    }
}

- (void)lockVoiceButton{
    _voiceName = @"";
    _playButton.hidden = YES;
    [_voiceView stopRecord];
    _markVioceButton.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(voiceButtonCancelLock) userInfo:nil repeats:NO];
}

- (void)voiceButtonCancelLock{
    
    if ([self.recordTool.recorder isRecording]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                _playButton.hidden = YES;
                [_voiceView stopRecord];
            });
        });
    }
    _markVioceButton.enabled = YES;
}
- (void)recordBtnDidTouchDragEnter:(UIButton *)recordBtn {
    [_voiceView setStatus:@"上滑取消录音"];
}
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    [_voiceView setStatus:@"松开取消录音"];
}

#pragma mark ------> 开始录音
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    __block BOOL bCanRecord = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    if (bCanRecord) {
        if ([self.recordTool.recorder isRecording]) [self.recordTool stopRecording];
        [self.recordTool startRecording];
        [_voiceView setStatus:@"正在录音...."];
        [_voiceView show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showCanotRecord];
        });
    }
}
- (void)showCanotRecord{
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"我知道了" action:^{}];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你拒绝了录音权限,请你去设置->隐私->麦克风"
                                                        message:@"允许长安民生整车使用你的麦克风"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:nil, nil];
    [alertView show];
}
// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    double currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 2) {
        [self lockVoiceButton];
        toast_showInfoMsg(@"说话时间太短", 200);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 已成功录音
                _playButton.hidden = NO;
                [_voiceView stopRecord];
                _voiceName = _recordTool.fileName;
                toast_showInfoMsg(@"录音成功", 200);
                NSLog(@"filePath:--------->%@",_recordTool.filePath);
            });
        });
    }
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragCancel:(UIButton *)recordBtn {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self lockVoiceButton];
            toast_showInfoMsg(@"已取消录音", 200);
        });
    });
}

#pragma mark - 播放录音
- (void)playVoice:(UIButton*)voiceButton{
    voiceButton.selected = !voiceButton.selected;
    if (voiceButton.selected) {
        [self.recordTool playRecordingFile];
    }else{
        [self.recordTool stopPlaying];
    }
}
#pragma mark ------->LVRecordTool Delegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no{
    NSLog(@"LVRecord :  ---->%d",no);
    [_voiceView showVoiceImageWith:no];
}
- (void)recordTool:(LVRecordTool *)recordTool didStopPlayingFlag:(BOOL)succefuly{
    _playButton.selected = NO;
}
#pragma mark -------> 切换录音和文字备注
- (void)markChangeClick:(UIButton *)button{
    button.selected = !button.selected;
    _markVioceButton.hidden = !_markVioceButton.hidden;
    _markTextView.hidden = !_markTextView.hidden;
    if (button.selected&&(![_voiceName isEmpty]||!_voiceName)) {
        _playButton.hidden = NO;
    }else{
        _playButton.hidden = YES;
    }
}

#pragma mark ----> 上报按钮
- (void)initSumbitView{
    UIButton *sumbitButton = [CCButton ButtonWithFrame:CGRectMake(0,SYSTEM_HEIGHT-50, SYSTEM_WIDTH, 50) cornerradius:0 title:@"提交" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] normalBackGrondImage:[UIImage imageNamed:@"3ebf43"] highLightImage:[UIImage imageNamed:@"229926"] target:self action:@selector(sumbitClick)];
    [self.view addSubview:sumbitButton];
}

#pragma mark ------------> 上报异常事件

- (void)sumbitClick{
    //    if (!_address||[_address isEmpty]) {
    //        [self getAddress];
    //        alert_showInfoMsg(@"还没有得到位置，请稍后再试");
    //        return;
    //    }
    //
    //    [SVProgressHUD showWithStatus:@"上报中..."];
    //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters put:accessToken() key:ACCESS_TOKEN];
    //    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    //    [event put:_markTextView.text key:@"description"];
    //    [event put:_address key:@"address"];
    //    [event put:[NSNumber numberWithFloat:_userLocation.latitude] key:@"latitude"];
    //    [event put:[NSNumber numberWithFloat:_userLocation.longitude] key:@"longitude"];
    //    if (_voiceName&&![_voiceName isEmpty]) {
    //        [event put:_voiceName key:@"voice"];
    //    }
    //    if (self.photos>0) {
    //        [event put:self.photos key:@"photos"];
    //    }
    //    NSNumber *time = [NSNumber numberWithDouble:[[SeverTimeManager defaultManager] currentTimeIntervarl]*1000];
    //    [event put:time key:@"time"];
    //
    //
    //    [parameters put:event key:@"event"];
    //    CCWeakSelf(self);
    //    [[HttpRequstManager requestManager] postWithRequestBodyString:UPLOAD_EVENT_ABNORMAL parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
    //        if (error) {
    //            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(error.domain, @"SeverError", @"上报失败")];
    //        }else{
    //            [SVProgressHUD showSuccessWithStatus:@"上报成功"];
    //            [weakself sumbitEventSucceed];
    //        }
    //    }];
}

- (void)sumbitEventSucceed{
    if (self.photos>0) {
        [[DBManager sharedManager] insertPhotosWithPhotoArray:self.photos];
    }
    if (_voiceName&&![_voiceName isEmpty]) {
        [[DBManager sharedManager] inserVoiceWithVoiceName:_voiceName];
    }
    [self naviBack];
}

#pragma mark ---> 返回 其他

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    CGRect frame = CGRectMake(0, SYSTEM_HEIGHT-200-keyboardHeight, SYSTEM_WIDTH, 200);
    [UIView animateWithDuration:0.25 animations:^{
        _reportReasonView.frame = frame;
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.25 animations:^{
        _reportReasonView.frame = CGRectMake(0, SYSTEM_HEIGHT-250, SYSTEM_WIDTH, 200);
    }];
}

- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    if ([self.recordTool.recorder isRecording]) [self.recordTool stopRecording];
    if ([self.recordTool.player isPlaying]) [self.recordTool stopPlaying];
    self.recordTool.recorder = nil;
    self.recordTool.delegate = nil;
    _addressManager.callBackHandler = nil;
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
