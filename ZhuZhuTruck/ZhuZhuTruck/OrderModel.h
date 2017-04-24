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
#import "EventModel.h"
@interface OrderModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *confirm_status;
@property (nonatomic, copy) NSString<Optional> *descrip;
@property (nonatomic, strong) NSArray<Optional,GoodModel> *goods;
@property (nonatomic, copy) NSString<Optional> *order_number;
@property (nonatomic, copy) NSString<Optional> *refer_order_number;
@property (nonatomic, strong) PickupContactsModel<Optional> *pickup_contacts;
@property (nonatomic, strong) DeliveryContactsModel<Optional> *delivery_contacts;
@property (nonatomic, strong) NSNumber<Optional> *delivery_photo_force;
@property (nonatomic, strong) NSNumber<Optional> *delivery_entrance_force;
@property (nonatomic, strong) NSNumber<Optional> *pickup_photo_force;
@property (nonatomic, strong) NSNumber<Optional> *pickup_entrance_force;
@property (nonatomic, strong) NSNumber<Optional> *lowest_tons_count;
@property (nonatomic, copy) NSString<Optional> *delivery_end_time_format;
@property (nonatomic, copy) NSString<Optional> *delivery_start_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_end_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_start_time_format;
@property (nonatomic, copy) NSString<Optional> *receiver_name;
@property (nonatomic, copy) NSString<Optional> *sender_name;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) NSString<Optional> *damaged;
@property (nonatomic, copy) NSString<Optional> *delete_status;
@property (nonatomic, strong) NSMutableArray<Optional> *scanCodes;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *halfway_events;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *delivery_events;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *delivery_sign_events;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *pickup_events;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *pickup_sign_events;
@property (nonatomic, strong) NSMutableArray<Optional,EventModel> *confirm_events;
@end
