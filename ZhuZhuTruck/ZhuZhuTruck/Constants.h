//
//  Constants.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/11/30.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://183.131.76.178:3006"
#define DRIVER_BASE_URL @"http://183.131.76.178:3002"

//local
//#define BASE_URL @"http://192.168.1.100:3006"
//#define DRIVER_BASE_URL @"http://192.168.1.100:3002"

#define APPVERSION @"2.0.0.9"
#define VERSIONNUMBER @"2009"

#define SIGN_IN @"/driver/signin"
#define SIGN_UP @"/driver/signup"
#define UPDATE_USER_INFO @"/tender/driver/updateDriverProfile"

#define GET_BYSTATUS @"/driver/order/getbystatus"
#define UPLOADEVENT @"/transport_event/upload"
#define QN_IMAGE_TOKEN @"/token/image/upload"
#define QN_VOICE_TOKEN @"/token/amr/upload"
#define UPLOADLOCATIONS @"/trace/multiupload"


#define GET_UNSTART_TENDER @"/tender/driver/getUnStartedListByDriver" //post
#define GET_TENDER_BY_STATUS @"/tender/driver/getStartedListByDriver" //post
#define USER_GRAB_TENDER @"/tender/driver/grab"  //post
#define USER_COMPARE_TENDER @"/tender/driver/compare"  //post
#define USER_ADD_CARD   @"/tender/driver/card/create"   //post
#define USER_ADD_TRUCK_CAR @"/tender/driver/truck/create"
#define USER_ADD_NEW_DRIVER @"/tender/driver/addNewDriver"
#define USER_GET_CARD_LIST @"/tender/driver/card/getListByDriver"
#define USER_GET_TRUCK_LIST @"/tender/driver/truck/getListByDriver"
#define USER_ASSGIN_ORDER_TO_TRUCK @"/tender/driver/assginDriver"
#define USER_GET_ORDER_TIMELINE @"/tender/driver/transportevent"
#define USER_GET_ORDER_TENDER_COUNT @"/tender/driver/dashboard"
#define USER_GET_TENDER_BY_ID   @"/tender/driver/getTenderByTenderId"
#define USER_SEARCH_DRIVERS @"/tender/driver/searchDrivers"
#define USER_ADD_DRIVERS_TO_OWNER @"/tender/driver/addDriversToOwner"
#define USER_ADD_NEW_DRIVER @"/tender/driver/addNewDriver"

//登录参数
#define USERNAME @"username"
#define PWD @"password"

#define QN_IMAGE_HEADER @"http://7xiwrb.com1.z0.glb.clouddn.com/"

//通知
#define USER_TOKEN_INVILID_NOTI @"user_token_invaild_noti"
#define RELOAD_DRIVER_ORDER_LIST_NOTI @"reload_driver_order_list_noti"
#define GET_JPUSH_REGISEDID_NOTI  @"jpsuh_register_id"

#define CustomErrorDomain @"not_internet_now"

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
    RobTenderSucceed,
    TonTenderUnStart,
    TonTenderOngoing,
    TonTenderSucceed,
    TonTenderFailed,
} TenderOrderStatus;


typedef enum : NSUInteger {
    ADD_ETC_CARD,
    ADD_OIL_CARD,
} UserAddCardType;

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

#define CCLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define CCLog(...)

#endif



#define CCWeakSelf(type)  __weak typeof(type) weak##type = type;
#define CCStrongSelf(type)  __strong typeof(type) type = weak##type;

#define SYSTEM_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_WIDTH  [[UIScreen mainScreen] bounds].size.width
