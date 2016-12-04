//
//  DBManager.m
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#define UPLOAD_VOICE_FILE_TABLE @"voices"
#define UPLOAD_PHOTOS_TABLE     @"photos"
#define UPLOAD_LOCATIONS_TABLE  @"locations"
#define ZHENGCHE_CHEJIA_TABLE   @"cars"

#import "DBManager.h"
#import <FMDB.h>
#import "CCUserData.h"
#import <JSONKit.h>
#import <JSONModel.h>
#import "NSString+Tool.h"

@implementation DBManager{
    //数据库对象
    FMDatabase *_database;
}

+ (DBManager *)sharedManager{
    static DBManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _database = [self loadDbWishDBName:@"shunshouzhuanqian.db"];
    }
    return self;
}
/**
 *  创建DB对象
 */
- (FMDatabase *)loadDbWishDBName:(NSString *)dbName{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    //dbName：数据库名称
    NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:dbName];
//    NSLog(@"数据库位置－－－－－－－%@",writableDBPath);
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath] ;
    if (![db open]) {
        NSLog(@"数据库未能创建/打开");
        NSLog(@"database open failed:%@",db.lastErrorMessage);
        return nil;
    }
    [self initDB:db];
    return db;
}
- (void)initDB:(FMDatabase *)db{
    
    /**
     *  开启数据库
     */
    if ([db open]){
        [db setShouldCacheStatements:YES];
    }
    if(![db tableExists:UPLOAD_VOICE_FILE_TABLE])//创建录音文件列表
    {
        /**
         *  字段：
         id 为主排序
         *   _id       :运单ID
         *   voicename :文件名称
         *   succeed   :上传失败
         */
        BOOL result =  [db executeUpdate:@"create table voices(serial integer PRIMARY KEY AUTOINCREMENT,"
                        "voicename char(1000),succeed integer)"];
        if (result) {
            NSLog(@"录音表创建成功");
        }else{
            NSLog(@"creatTable error:%@",_database.lastErrorMessage);
        }
    }
    if(![db tableExists:UPLOAD_PHOTOS_TABLE])//创建照片列表
    {
        /**
         *  字段：
         *   id           :为主排序
         *   photoname    :照片的key
         *   succeed      :上传成功与否
         */
        BOOL result =  [db executeUpdate:@"create table photos(serial integer PRIMARY KEY AUTOINCREMENT,"
                        "photoname char(1000),succeed integer)"];
        if (result) {
            NSLog(@"照片表创建成功");
        }else{
            NSLog(@"creatTable error:%@",_database.lastErrorMessage);
        }
    }
    if(![db tableExists:UPLOAD_LOCATIONS_TABLE])//创建地址列表
    {
        /**
         *  字段：
         *   location_info:地址详情 json
         *   time         :时间排序用
         *   access_token :用户凭证
         */
        BOOL result =  [db executeUpdate:@"create table locations(serial integer PRIMARY KEY AUTOINCREMENT,"
                        "location_info text,time date,access_token text)"];
        if (result) {
            NSLog(@"地址表创建成功");
        }else{
            NSLog(@"creatTable error:%@",_database.lastErrorMessage);
        }
    }

}

- (BOOL)inserPhotoWithPhotoName:(NSString *)photoName{
    //判断是否打开
    if ([_database open]) {
        if (![self isPhotoExistWithPhotoName:photoName]) {
            NSString *sql = @"insert into photos(photoname,succeed) values (?,?)";
            BOOL succeed = [_database executeUpdate:sql,photoName,[NSNumber numberWithBool:NO]];
            if (!succeed) {
                NSLog(@"insert error:%@",_database.lastErrorMessage);
                return NO;
            }else{
                NSLog(@"插入照片成功 " );
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isPhotoExistWithPhotoName:(NSString *)photoName{
    
    NSString *sql = @"select * from photos where photoname = ?";
    FMResultSet *rs = [_database executeQuery:sql,photoName];
    //查询结果集合
    while ([rs next]) {
        return YES;
    }
    return NO;
}

- (void)insertPhotosWithPhotoArray:(NSArray *)photoArray{
    for (NSString *photoName in photoArray) {
        [self inserPhotoWithPhotoName:photoName];
    }
}

- (NSArray*)readAllUnUploadPhotos{
    NSMutableArray *array =[[NSMutableArray alloc] init];
    NSString *sql = @"select * from photos where succeed = ?";
    FMResultSet *rs = [_database executeQuery:sql,[NSNumber numberWithBool:NO]];
    //查询结果集合
    while ([rs next]) {
        NSString *photoName = [rs stringForColumn:@"photoname"];
        [array addObject:photoName];
    }
    return array;
}
- (BOOL)photoUploadSucceedWithPhotoName:(NSString *)photoName{
    NSString *sql = @"update photos set succeed = ? where photoname = ?";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql,
                        [NSNumber numberWithBool:YES],
                        photoName];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}

- (BOOL)photoDeletedWithPhotoName:(NSString *)photoName{
    NSString *sql = @"delete from photos where photoname = ?";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql,photoName];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}

- (BOOL)inserVoiceWithVoiceName:(NSString *)voiceName{
    //判断是否打开
    if ([_database open]) {
        if (![self isPhotoExistWithPhotoName:voiceName]) {
            NSString *sql = @"insert into voices(voicename,succeed) values (?,?)";
            BOOL succeed = [_database executeUpdate:sql,voiceName,[NSNumber numberWithBool:NO]];
            if (!succeed) {
                NSLog(@"insert error:%@",_database.lastErrorMessage);
                return NO;
            }else{
                NSLog(@"插入语音成功" );
                return YES;
            }
        }
    }
    return NO;
}
- (BOOL)isVoiceExistWithVoiceName:(NSString *)voiceName{
    
    NSString *sql = @"select * from voices where voicename = ?";
    FMResultSet *rs = [_database executeQuery:sql,voiceName];
    //查询结果集合
    while ([rs next]) {
        return YES;
    }
    return NO;
}

- (NSArray*)readAllUnUploadVoices{
    NSMutableArray *array =[[NSMutableArray alloc] init];
    NSString *sql = @"select * from voices where succeed = ?";
    FMResultSet *rs = [_database executeQuery:sql,[NSNumber numberWithBool:NO]];
    //查询结果集合
    while ([rs next]) {
        NSString *voiceName = [rs stringForColumn:@"voicename"];
        [array addObject:voiceName];
    }
    return array;
}
- (BOOL)voiceUploadSucceedWithVoiceName:(NSString *)voiceName{
    NSString *sql = @"update voices set succeed = ? where voiceName = ?";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql,
                        [NSNumber numberWithBool:YES],
                        voiceName];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}

- (BOOL)voiceDeleteWithVoiceName:(NSString *)voiceName{
    NSString *sql = @"delete from voices where voiceName = ?";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql,voiceName];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}

- (BOOL)inserLocationWithLocationInfo:(NSString *)locationInfo{
    //判断是否打开 "location_info text,time char(100),access_token text,succeed integer)
    if ([_database open]) {
        NSString *sql = @"insert into locations(location_info,time,access_token) values (?,?,?)";
        BOOL succeed = [_database executeUpdate:sql,locationInfo,[NSDate date],@""];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
            return NO;
        }else{
            NSLog(@"插入地址成功" );
            return YES;
        }
    }
    return NO;
}
- (NSArray*)readAllLocations{
    NSMutableArray *array =[[NSMutableArray alloc] init];
    NSString *sql = @"select * from locations";
    FMResultSet *rs = [_database executeQuery:sql,[NSNumber numberWithBool:NO]];
    //查询结果集合
    while ([rs next]) {
        NSString *locationInfo = [rs stringForColumn:@"location_info"];
        [array addObject:locationInfo];
    }
    return array;
}
- (BOOL)deleteLocationWithInfo:(NSString *)locationInfo{
    NSString *sql = @"delete from locations where location_info = ?";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql,locationInfo];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}
- (void)deleteLocationsWithLoctions:(NSArray *)locations{
    for (NSString *locationInfo in locations) {
        [self deleteLocationWithInfo:locationInfo];
    }
}
- (BOOL)deletedAllLocations{
    NSString *sql = @"delete from locations";
    if ([_database open]) {
        BOOL succeed = [_database executeUpdate:sql];
        if (!succeed) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        return succeed;
    }
    return NO;
}



@end
