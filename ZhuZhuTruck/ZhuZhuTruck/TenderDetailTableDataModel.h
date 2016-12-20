//
//  TenderDetailTableDataModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TenderModel.h"
#import "TenderDetailCellModel.h"

@interface TenderDetailTableDataModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataArray;
- (instancetype)initWithModel:(TenderModel*)model;
@end
