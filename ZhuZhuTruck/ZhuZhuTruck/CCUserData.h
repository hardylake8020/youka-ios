//
//  CCUserData.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_APP_VERSION       @"user_app_version"
#define USER_NICK_NAME         @"nickname"
#define USER_HEAD_PHOTO        @"head_photo"
#define QN_TOKEN               @"qn_token"
#define ACCESS_TOKEN           @"access_token"
#define USER_PHONE_NUMBER      @"mobile_phone"
#define USER_PWD               @"password"
#define USER_TYPE              @"user_type"
#define USER_PUSH_ID           @"push_id"
#define USER_CARRIER_NAME      @"carrier_name"
#define USER_CARRIER_ADDRESS   @"carrier_address"
#define USER_DEST_NAME         @"dest_name"
#define USER_DEST_ADDRESS      @"dest_address"
#define USER_ORDER_COUNT       @"order_count"
#define USER_TENDER_COUNT      @"tender_count"


void save_AppVersion(NSString* appVersion);
NSString* app_version();
void save_UserNickName(NSString* userName);
NSString* user_NickName();
void save_UserPwd(NSString* userName);
NSString* user_Pwd();
void save_AccessToken(NSString* accessToken);
NSString* accessToken();
void save_UserHeadPhoto(NSString* userHeadPhoto);
NSString* user_headPhoto();
void save_qntoken(NSString* qntoken);
NSString* qn_token();
void save_userPhone(NSString* phone);
NSString* user_phone();
void save_userType(int type);
int user_type();
void save_PushId(NSString* pushId);
NSString* user_PushId();
void save_carrierName(NSString* carrier_name);
NSString* user_carrierName();
void save_carrierAddress(NSString* carrier_address);
NSString* user_carrierAddress();
void save_destName(NSString* dest_name);
NSString* user_destName();
void save_destAddress(NSString* dest_address);
NSString* user_destAddress();
void save_orderCount(int count);
int order_count();
void save_tenderCount(int count);
int tender_count();










