//
//  AddTruckTypeViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddtypeCallBack)(NSString *truckType);

@interface AddTruckTypeViewController : BaseViewController

- (instancetype)initWithInfoDict:(NSDictionary*)infoDict andCallback:(AddtypeCallBack)callBack;
- (instancetype)initWithInfoModel:(PersonInfoModel*)model andCallback:(AddtypeCallBack)callBack;
@end
