//
//  OrderDetailsModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodModel.h"

@protocol OrderDetailsModel <NSObject>
@end

@interface OrderDetailsModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *goods_name;
@property (nonatomic, copy) NSString<Optional> *count_unit;
@property (nonatomic, copy) NSString<Optional> *weight_unit;
@property (nonatomic, copy) NSString<Optional> *volume_unit;
@end
