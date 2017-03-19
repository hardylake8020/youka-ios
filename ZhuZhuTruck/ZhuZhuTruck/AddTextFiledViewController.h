//
//  AddTextFiledViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddTextCallBack)(NSString *textString);

@interface AddTextFiledViewController : BaseViewController
- (instancetype)initWithInfoDict:(NSDictionary *)infoDict andCallBack:(AddTextCallBack)callBack;
- (instancetype)initWithInfoModel:(PersonInfoModel *)model andCallBack:(AddTextCallBack)callBack;
@end
