//
//  WaybillCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface WaybillCell : UITableViewCell
- (void)showCellWithOrderModel:(OrderModel*)model;
@end
