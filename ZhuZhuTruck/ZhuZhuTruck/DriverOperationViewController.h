//
//  DriverOperationViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SingInBlock)();

@interface DriverOperationViewController : BaseViewController

- (instancetype)initWithDriverOperationType:(DriverOperationType)type andOrderModel:(OrderModel *)orderModel;
- (instancetype)initWithDriverOperationType:(DriverOperationType)type andOrderModel:(OrderModel *)orderModel andSigninCallBack:(SingInBlock)callback;
@end
