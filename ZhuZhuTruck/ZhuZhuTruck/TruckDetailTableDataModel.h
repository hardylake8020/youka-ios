//
//  TruckDetailTableDataModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/24.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TruckModel.h"
#import "TruckDetailCellModel.h"
@interface TruckDetailTableDataModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataArray;
- (instancetype)initWithTruckModel:(TruckModel *)model;
@end
