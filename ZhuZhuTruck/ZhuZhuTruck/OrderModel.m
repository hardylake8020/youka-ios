//
//  OrderModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"descrip"}];
}
@end
