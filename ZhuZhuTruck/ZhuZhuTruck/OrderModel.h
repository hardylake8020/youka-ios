//
//  OrderModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderDetailsModel.h"
#import "PickupContactsModel.h"
#import "DeliveryContactsModel.h"

@interface OrderModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *confirm_status;
@property (nonatomic, copy) NSString<Optional> *descrip;
@property (nonatomic, strong) OrderDetailsModel<Optional> *order_details;
@property (nonatomic, strong) PickupContactsModel<Optional> *pickup_contacts;
@property (nonatomic, strong) DeliveryContactsModel<Optional> *delivery_contacts;
@property (nonatomic, strong) NSNumber<Optional> *delivery_photo_force;
@property (nonatomic, strong) NSNumber<Optional> *delivery_entrance_force;
@property (nonatomic, strong) NSNumber<Optional> *pickup_photo_force;
@property (nonatomic, strong) NSNumber<Optional> *pickup_entrance_force;
@property (nonatomic, copy) NSString<Optional> *delivery_end_time_format;
@property (nonatomic, copy) NSString<Optional> *delivery_start_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_end_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_start_time_format;
@property (nonatomic, copy) NSString<Optional> *receiver_name;
@property (nonatomic, copy) NSString<Optional> *sender_name;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) NSString<Optional> *damaged;
@end
