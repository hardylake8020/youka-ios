//
//  PersonInfoModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PersonInfoModel.h"

@implementation PersonInfoModel
- (instancetype)initWithTitle:(NSString*)title photoName:(NSString *)photoName andKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _title = title;
        _photoName = photoName;
        _key = key;
    }
    return self;
}


@end
