//
//  TakePhotoModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "TakePhotoModel.h"

@implementation TakePhotoModel
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
- (NSString *)photoName{
    return _photoName?_photoName:@"";
}
@end
