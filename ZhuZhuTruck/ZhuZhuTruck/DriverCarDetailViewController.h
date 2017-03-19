//
//  DriverCarDetailViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SucceedCallBack)();

@interface DriverCarDetailViewController : BaseViewController
- (instancetype)initWithTruckModel:(TruckModel *)model;
- (instancetype)initWithDriverModel:(DriverModel *)model andSucceedCallBack:(SucceedCallBack)callBack;
@end
