//
//  DeliveryContactsModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DeliveryContactsModel <NSObject>
@end

@interface DeliveryContactsModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *phone;
@property (nonatomic, copy) NSString<Optional> *mobile_phone;
@property (nonatomic, copy) NSString<Optional> *address;
@end
