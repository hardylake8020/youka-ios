//
//  QRCodeVC.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIViewExt.h"
#import "UIAlertView+Blocks.h"
#define screen_width self.view.bounds.size.width
#define screen_height self.view.bounds.size.height

@interface QRCodeVC()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
    float _screenwidth;
    float _screenHight;
}
@property (nonatomic,copy) QRCodeCallBackBlock callBackHandler;
@end

@implementation QRCodeVC

- (instancetype)initWithCallBackHandler:(QRCodeCallBackBlock)callBackHandler
{
    self = [super init];
    if (self) {
        self.callBackHandler = callBackHandler;
    }
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%f",screen_height);
    
    if (screen_height>screen_width) {
        _screenHight = screen_height;
        _screenwidth = screen_width;
    }
    else{
        _screenHight = screen_width;
        _screenwidth = screen_height;
    }
    
    //扫描区域
    CGRect areaRect = CGRectMake((_screenwidth - 218)/2, (_screenHight - 218)/2, 218, 218);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:CGRectMake(0, 0, _screenwidth, _screenHight)];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    //label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(12, 26, 42, 42);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"我知道了" action:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你拒绝了拍照权限,请你去设置->隐私->相机"
                                                            message:@"允许长安民生整车使用你的相机"
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:nil, nil];
        [alertView show];
        return;
    }
    
    
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.y/_screenHight, _areaView.x/_screenwidth, _areaView.height/_screenHight, _areaView.width/_screenwidth);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=CGRectMake(0, 0, _screenwidth, _screenHight);

    [self.view.layer insertSublayer:layer atIndex:0];

    //开始捕获
    [session startRunning];
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        [_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (!metadataObject) {
            return;
        }
        NSLog(@"%@",metadataObject.stringValue);
        if (self.callBackHandler) {
            self.callBackHandler(metadataObject.stringValue);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//点击返回按钮回调
-(void)clickBackButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (void)dealloc{
    NSLog(@"SCAN VC delloc");
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBarHidden = YES;
//}

@end
