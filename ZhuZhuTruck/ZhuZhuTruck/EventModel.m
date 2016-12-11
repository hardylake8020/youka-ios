//
//  EventModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"descrip"}];
}
@end
