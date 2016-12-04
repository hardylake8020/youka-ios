//
//  AddressManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/29.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

typedef void(^GetCurrentAddressCallBack)(NSString *address,CLLocationCoordinate2D location);

@interface AddressManager : NSObject
@property (nonatomic, copy)GetCurrentAddressCallBack callBackHandler;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, copy ) NSString              *currentAddress;
+ (id)sharedManager;
- (void)getCurentAddressWithCallBackHandler:(GetCurrentAddressCallBack)callBack;
@end
