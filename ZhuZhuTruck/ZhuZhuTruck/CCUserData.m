//
//  CCUserData.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCUserData.h"

NSUserDefaults* userDefaults;

void getUserDefaults()
{
    if(userDefaults==nil)
        userDefaults=[NSUserDefaults standardUserDefaults];
}
/**
 <#Description#> 保存String
 @param key <#key description#>
 @param value <#value description#>
 */

void saveString(NSString* key,NSString* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#> 保存Bool
 @param key <#key description#>
 @param value <#value description#>
 */
void saveBool(NSString* key,BOOL value)
{
    getUserDefaults();
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#>保存Integer
 @param key <#key description#>
 @param value <#value description#>
 */
void saveInteger(NSString* key,int value)
{
    getUserDefaults();
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#>保存Float
 @param key <#key description#>
 @param value <#value description#>
 */
void saveFloat(NSString* key,float value)
{
    getUserDefaults();
    [userDefaults setFloat:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Double
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDouble(NSString* key,double value)
{
    getUserDefaults();
    [userDefaults setDouble:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Date
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDate(NSString* key,NSDate* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Array
 @param key <#key description#>
 @param value <#value description#>
 */
void saveArray(NSString* key,NSArray* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Dictionary
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDictionary(NSString* key,NSDictionary* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存data
 @param key <#key description#>
 @param value <#value description#>
 */
void saveData(NSString* key,NSData* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}
/**
 <#Description#> 获取String
 @param key <#key description#>
 @returns <#return value description#>
 */
NSData* getData(NSString* key)
{
    getUserDefaults();
    NSData* value=[userDefaults dataForKey:key];
    return value;
}

/**
 <#Description#> 获取String
 @param key <#key description#>
 @returns <#return value description#>
 */
NSString* getString(NSString* key)
{
    getUserDefaults();
    NSString* value=[userDefaults stringForKey:key];
    return value==nil?@"":value;
}

/**
 <#Description#>获取bool
 @param key <#key description#>
 @returns <#return value description#>
 */
bool getBool(NSString* key)
{
    getUserDefaults();
    return [userDefaults boolForKey:key];
}


/**
 <#Description#> 获取Integer
 @param key <#key description#>
 @returns <#return value description#>
 */
int getInteger(NSString* key)
{
    getUserDefaults();
    return (int)[userDefaults integerForKey:key];
}


/**
 <#Description#> 获取Float
 @param key <#key description#>
 @returns <#return value description#>
 */
float getFloat(NSString* key)
{
    getUserDefaults();
    return [userDefaults floatForKey:key];
}


/**
 <#Description#> 获取Double
 @param key <#key description#>
 @returns <#return value description#>
 */
double getDouble(NSString* key)
{
    getUserDefaults();
    return [userDefaults doubleForKey:key];
}

/**
 <#Description#> 获取Array
 @param key <#key description#>
 @returns <#return value description#>
 */
NSArray* getArray(NSString* key)
{
    getUserDefaults();
    return [userDefaults arrayForKey:key];
}

/**
 <#Description#> 获取Dictionary
 @param key <#key description#>
 @returns <#return value description#>
 */
NSDictionary* getDictionary(NSString* key)
{
    getUserDefaults();
    return [userDefaults dictionaryForKey:key];
}


/**
 Description:保存用户版本号
 @param appVersion userName description
 */
void save_AppVersion(NSString* appVersion)
{
    saveString(USER_APP_VERSION,appVersion);
}

/**
 <#Description#> 获取用户版本号
 @returns <#return value description#>
 */
NSString* app_version()
{
    return getString(USER_APP_VERSION);
}


/**
 Description:保存用户名
 @param userName userName description
 */
void save_UserNickName(NSString* userName)
{
    saveString(USER_NICK_NAME,userName);
}

/**
 <#Description#> 获取用户名
 @returns <#return value description#>
 */
NSString* user_NickName()
{
    return getString(USER_NICK_NAME);
}


/**
 Description:保存用户头像
 @param userHeadPhoto userName description
 */
void save_UserHeadPhoto(NSString* userHeadPhoto)
{
    saveString(USER_HEAD_PHOTO,userHeadPhoto);
}

/**
 <#Description#> 获取用户头像
 @returns <#return value description#>
 */
NSString* user_headPhoto()
{
    return getString(USER_HEAD_PHOTO);
}



/**
 Description:保存accessToken
 @param accessToken userName description
 */
void save_AccessToken(NSString* accessToken)
{
    saveString(ACCESS_TOKEN,accessToken);
}

/**
 <#Description#> 获取用accessToken
 @returns <#return value description#>
 */
NSString* accessToken()
{
    return getString(ACCESS_TOKEN);
}


/**
 Description:保存用户 QN token
 @param qntoken userName description
 */
void save_qntoken(NSString* qntoken)
{
    saveString(QN_TOKEN,qntoken);
}

/**
 <#Description#> 获取QN token
 @returns <#return value description#>
 */
NSString* qn_token()
{
    return getString(QN_TOKEN);
}

/**
 Description:保存用户电话
 @param phone userName description
 */
void save_userPhone(NSString* phone)
{
    saveString(USER_PHONE_NUMBER,phone);
}

/**
 <#Description#> 获取电话
 @returns <#return value description#>
 */
NSString* user_phone()
{
    return getString(USER_PHONE_NUMBER);
}
/**
 <#Description#>保存密码
 @param userpwd <#userpwd description#>
 */
void save_UserPwd(NSString* userpwd)
{
    saveString(USER_PWD,userpwd);
}

/**
 <#Description#>获取密码
 @returns <#return value description#>
 */
NSString* user_Pwd()
{
    return getString(USER_PWD);
}

/**
 <#Description#>保存用户类型
 @param type <#userpwd description#>
 */
void save_userType(int type)
{
    saveInteger(USER_TYPE, type);
}

/**
 <#Description#>获取用户类型
 @returns <#return value description#>
 */
int user_type()
{
    return getInteger(USER_TYPE);
}


/**
 Description保存推送id
 @param pushId pushId description
 */
void save_PushId(NSString* pushId)
{
    saveString(USER_PUSH_ID,pushId);
}

/**
 Description获取推送id
 @returns return value description
 */
NSString* user_PushId()
{
    return getString(USER_PUSH_ID);
}


/**
 <#Description#>保存运单数量
 @param count <#userpwd description#>
 */
void save_orderCount(int count)
{
    saveInteger(USER_ORDER_COUNT, count);
}

/**
 <#Description#>获取用户运单数量
 @returns <#return value description#>
 */
int order_count()
{
    return getInteger(USER_ORDER_COUNT);
}


/**
 <#Description#>保存用户订单数量
 @param count <#userpwd description#>
 */
void save_tenderCount(int count)
{
    saveInteger(USER_TENDER_COUNT, count);
}

/**
 <#Description#>获取用户订单数量
 @returns <#return value description#>
 */
int tender_count()
{
    return getInteger(USER_TENDER_COUNT);
}







