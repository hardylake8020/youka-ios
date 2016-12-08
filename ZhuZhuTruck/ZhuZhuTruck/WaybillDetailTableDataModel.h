//
//  WaybillDetailTableDataModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaybillDetailCellModel.h"
#import "OrderModel.h"
@interface WaybillDetailTableDataModel : NSObject
- (instancetype)initWithModel:(OrderModel*)model;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
