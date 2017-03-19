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
#define USER_ID                @"_id"
#define USER_HEAD_PHOTO        @"head_photo"
#define QN_TOKEN               @"qn_token"
#define ACCESS_TOKEN           @"access_token"
#define USER_PHONE_NUMBER      @"username"
#define USER_PWD               @"password"
#define USER_TYPE              @"user_type"
#define USER_PUSH_ID           @"push_id"
#define USER_CARRIER_NAME      @"carrier_name"
#define USER_CARRIER_ADDRESS   @"carrier_address"
#define USER_DEST_NAME         @"dest_name"
#define USER_DEST_ADDRESS      @"dest_address"
#define USER_ORDER_COUNT       @"order_count"
#define USER_TENDER_COUNT      @"tender_count"
#define USER_IDENTIY_CARD      @"id_card_number"
#define USER_BANK_CARD         @"bank_number"

#define UER_TRUCK_PHOTO        @"truck_photo"
#define UER_ID_CARD_PHOTO      @"id_card_photo"
#define UER_BANK_CARD_PHOTO    @"bank_number_photo"
#define UER_DRIVING_LICENSE_PHOTO @"driving_id_photo"
#define UER_VEIHCLEL_LICENDE_PHOTO @"travel_id_photo"
#define UER_TRUCK_LIST_PHOTO   @"truck_list_photo"
#define UER_PLATE_PHOTO        @"plate_photo"

#define UER_TRUCK_NUMBER       @"truck_number"
#define UER_TRUCK_TYPE         @"truck_type"



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
void save_UseId(NSString* user_id);
NSString* user_id();
void save_identiyCard(NSString* identiyCard);
NSString* user_identiyCard();
void save_bankCard(NSString* bankCard);
NSString* user_bankCard();

void save_truckPhoto(NSString* photo);
NSString* user_truckPhoto();
void save_idCardPhoto(NSString* photo);
NSString* user_idCardPhoto();
void save_driverLicensePhoto(NSString* photo);
NSString* user_driverLicensePhoto();
void save_bankCardPhoto(NSString* photo);
NSString* user_bankCardPhoto();
void save_vehicleLicensePhoto(NSString* photo);
NSString* user_vehicleLicensePhoto();
void save_platePhoto(NSString* photo);
NSString* user_platePhoto();
void save_truckListPhoto(NSString* photo);
NSString* user_truckListPhoto();
void save_truckNumber(NSString* number);
NSString* user_truckNumber();
void save_truckType(NSString* type);
NSString* user_truckType();
void save_userProfiles(NSDictionary *driver);
void clearUserProfile();




