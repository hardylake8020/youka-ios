//
//  DriverTimeLineViewController.h
//  
//
//  Created by CongCong on 2016/12/3.
//
//

#import "BaseViewController.h"

@interface DriverTimeLineViewController : BaseViewController
- (instancetype)initWithOrderModel:(OrderModel *)model;
- (instancetype)initWithTenderId:(NSString *)tenderId;
@end
