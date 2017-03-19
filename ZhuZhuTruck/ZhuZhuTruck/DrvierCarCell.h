//
//  DrvierCarCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TruckModel.h"
#import "DriverModel.h"
@interface DrvierCarCell : UITableViewCell
- (void)showTruckCellWithModel:(TruckModel *)model;
- (void)showSeletedTruckCellWithModel:(TruckModel *)model;
- (void)showDriverCellWithDriverModel:(DriverModel*)model;
@end
