//
//  AddressManager.m
//  ZhengChe
//
//  Created by CongCong on 16/9/29.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AddressManager.h"
#import "CCAlert.h"
#import "Constants.h"
@interface AddressManager ()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    //添加地理反编码
    BMKGeoCodeSearch   *_search;
}

@end

@implementation AddressManager
+(id)sharedManager{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
       [self initLoactionService];
    }
    return self;
}

- (void)initLoactionService{
    _locService = [[BMKLocationService alloc] init];
    [_locService setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    _locService.delegate =self;
    _search = [[BMKGeoCodeSearch alloc]init];
    _search.delegate = self;
    [self repeatGetAdress];
     [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(repeatGetAdress) userInfo:nil repeats:YES];
}

- (void)repeatGetAdress{
    [_locService startUserLocationService];
}


- (void)getCurentAddressWithCallBackHandler:(GetCurrentAddressCallBack)callBack{

    self.callBackHandler = callBack;
    if (self.callBackHandler) {
        self.callBackHandler(self.currentAddress,self.currentLocation);
    }
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude!=0&&userLocation.location.coordinate.longitude!=0) {
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        self.currentLocation = userLocation.location.coordinate;
        reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag){
            NSLog(@"反geo检索发送成功");
            [_locService stopUserLocationService];
        }
        else{
            NSLog(@"反geo检索发送失败");
        }
    }
}
#pragma mark -->地理反编码回调函数
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result);
    if (error == BMK_SEARCH_NO_ERROR){
        self.currentAddress = result.address;
        CCLog(@"------>%@",self.currentAddress);
        if (self.callBackHandler) {
            self.callBackHandler(self.currentAddress,self.currentLocation);
        }
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            alert_showErrMsg(@"网络连接失败，请检查网络连接。");
        }
            break;
        case kCLErrorDenied:{
            alert_showErrMsg(@"定位服务未启用,请到隐私->定位服务->开启,否则定位无法完成.");
        }
            break;
        default:
            break;
    }
//    [_locService stopUserLocationService];
}


@end
