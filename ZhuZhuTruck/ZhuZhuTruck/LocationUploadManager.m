//
//  LocationUploadManager.m
//  ZhengChe
//
//  Created by CongCong on 16/9/27.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "LocationUploadManager.h"
#import "NSDictionary+Tool.h"
#import "NSMutableDictionary+Tool.h"
#import "Constants.h"
#import "DBManager.h"
#import "NSString+Tool.h"
#import "CCUserData.h"
#import "HttpRequstManager.h"

@interface LocationUploadManager (){
    
}
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, assign) BOOL isUploading;
@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation LocationUploadManager

+(id)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (NSMutableArray*)locationArray{
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbManager = [DBManager sharedManager];
//        [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(startUploadArray) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)startUploadArray{
    
    [self.locationArray removeAllObjects];
    [self.locationArray addObjectsFromArray:[_dbManager readAllLocations]];
    if (self.locationArray.count>0&&!self.isUploading) {
        if (self.locationArray.count>50) {
            [self uploadToServerWithLoactions:[self.locationArray subarrayWithRange:NSMakeRange(0, 50)]];
        }else{
            [self uploadToServerWithLoactions:self.locationArray];
        }
    }
}
- (void)uploadToServerWithLoactions:(NSArray *)locationArray{
    
    if ([accessToken() isEmpty]) {
        return;
    }
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:locationArray key:@"trace_infos"];
    [[HttpRequstManager requestManager] postWithRequestBodyString:UPLOADLOCATIONS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        weakself.isUploading = NO;
        if (error) {
            
            CCLog(@"LocationUploadERROR-------->%@",error.domain);
            if ([error.domain isEqualToString:@"trace_time_invalid"]||[error.domain isEqualToString:@"trace_info_invalid"]||[error.domain isEqualToString:@"trace_location_type_invalid"]) {
                [_dbManager deleteLocationsWithLoctions:locationArray];
            }
            
            if (error.code == -404) {
                return ;
            }
            
        }else{
            CCLog(@"LocationUploadResult-------->%@",result);
            [weakself.dbManager deleteLocationsWithLoctions:locationArray];
            if ([weakself.dbManager readAllLocations].count>15) {
                [weakself performSelector:@selector(startUploadArray) withObject:nil afterDelay:5];
            }
        }
    }];
}
@end
