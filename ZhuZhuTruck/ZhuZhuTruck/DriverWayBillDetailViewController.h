//
//  DriverWayBillDetailViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

@interface DriverWayBillDetailViewController : BaseViewController
- (instancetype)initWithWillbillStaus:(WaybillStatus)status;
- (instancetype)initWithWillbillStaus:(WaybillStatus)status andOrderModel:(OrderModel *)orderModel;
@end
