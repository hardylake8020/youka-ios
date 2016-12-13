//
//  SeverTimeManager.m
//  ZhengChe
//
//  Created by CongCong on 16/9/23.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "SeverTimeManager.h"
#import "HttpRequstManager.h"
#import "Constants.h"
#import "NSDictionary+Tool.h"
#import "NSMutableDictionary+Tool.h"
@interface SeverTimeManager (){
    NSTimer *_getNewCurrentTimer;//每1s更新一次时间每5分钟取一次时间
    NSTimer *_StopRunTimer;//进入后台超过3分钟停止运行清空时间
    NSInteger _updateTimerCount;//超过5取一次时间
    BOOL _isLoading;
}

@end


@implementation SeverTimeManager
+(id)defaultManager{
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
        _updateTimerCount = 0;
        _currentTimeIntervarl = 0;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [self getServerTime];
//        _getNewCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentDate) userInfo:nil repeats:YES];
    }
    return self;
}
- (NSTimeInterval)currentTimeIntervarl{
    if (_currentTimeIntervarl<NSTimeIntervalSince1970) {
        [self getServerTime];
        return [[NSDate date] timeIntervalSince1970];
    }
    return _currentTimeIntervarl;
}
- (void)updateCurrentDate{
    
    if (_currentTimeIntervarl<NSTimeIntervalSince1970) {//978307200
        [self getServerTime];
        return;
    }
    _updateTimerCount++;
    if (_updateTimerCount>=300&&!_isLoading) {
        [self getServerTime];
    }else{
        _currentTimeIntervarl += 1;
        _currentDate = [[NSDate alloc]initWithTimeIntervalSince1970:_currentTimeIntervarl];
//        NSLog(@"TimeInterval------------>:%@",[self dateStringWith:_currentDate]);
    }
}

- (NSString *)dateStringWith:(NSDate*)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式 2016-08-10T09:44:01.606Z
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS Z"];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:date];
}
- (void)getServerTime{
    
    _isLoading = YES;
#warning url
    [[HttpRequstManager requestManager] getWithRequestBodyString:@"" parameters:nil resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"获取网络时间失败");
        }else{
            NSLog(@"servertime:------->%@",result);
            _currentTimeIntervarl = [result doubleForKey:@"timestamp"]/1000.000;
            _updateTimerCount = 0;
        }
        _isLoading = NO;
    }];
}

- (void)applicationWillBecomeActive{
    if (![_getNewCurrentTimer isValid]) {
        [self getServerTime];
        _getNewCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentDate) userInfo:nil repeats:YES];
    }
}
//
//- (void)applicationEnterBackground{
//    _StopRunTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(appNotRun) userInfo:nil repeats:NO];
//}
//
//- (void)appNotRun{
//    [_getNewCurrentTimer invalidate];
//    [_StopRunTimer invalidate];
//    _currentTimeIntervarl = 0;
//    _updateTimerCount = 0;
//}
@end
