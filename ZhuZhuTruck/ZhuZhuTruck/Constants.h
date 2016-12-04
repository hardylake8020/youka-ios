//
//  Constants.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/11/30.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define BASE_URL @"http://101.66.253.182:3002"//测试环境
#define BASE_URL @"http://192.168.0.109:3002"//本地测试

#define APPVERSION @"1.0.0.1"
#define VERSIONNUMBER @"1001"



typedef enum : NSUInteger {
    PickupSign,
    PickupSucceed,
    DeliveySign,
    DeliveySucceed,
    HalfWayEvent,
} DriverOperationType;

typedef enum : NSUInteger {
    UnpickupedStatus,
    UndeliveryedStatus,
    SucceedDelvieryStatus,
} WaybillStatus;

typedef enum : NSUInteger {
    BidTenderUnStart,
    BidTenderOngoing,
    BidTenderSucceed,
    BidTenderFailed,
    RobTenderUnStart,
    RobTenderOngoing,
    RobTenderSucceed,
    RobTenderFailed,
} TenderOrderStatus;

//圆角大小
#define CORNERRADIUS 6.0f
//标题栏参数
#define SYSTITLEHEIGHT    64.0f
#define BOTTOMHEIGHT 40.0f

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef DEBUG
#define CCLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define CCLog(...)

#endif

#define CCWeakSelf(type)  __weak typeof(type) weak##type = type;
#define CCStrongSelf(type)  __strong typeof(type) type = weak##type;

#define SYSTEM_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_WIDTH  [[UIScreen mainScreen] bounds].size.width
