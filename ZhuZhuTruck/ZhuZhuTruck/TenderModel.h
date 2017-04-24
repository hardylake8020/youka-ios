//
//  TenderModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/13.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodModel.h"
#import "WinnerModel.h"
#import "TenderRecordModel.h"
#import "ExecuteDriverModel.h"

@interface TenderModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *tender_number;
@property (nonatomic, copy) NSString<Optional> *order_number;
@property (nonatomic, copy) NSString<Optional> *truck;
@property (nonatomic, copy) NSString<Optional> *truck_number;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *refer_order_number;
@property (nonatomic, copy) NSString<Optional> *sender_company;
@property (nonatomic, copy) NSString<Optional> *pay_approver;
@property (nonatomic, copy) NSString<Optional> *start_time;
@property (nonatomic, copy) NSString<Optional> *end_time;
@property (nonatomic, copy) NSString<Optional> *truck_type;
@property (nonatomic, copy) NSString<Optional> *tender_type;//grab 
@property (nonatomic, copy) NSString<Optional> *auto_close_time;
@property (nonatomic, copy) NSString<Optional> *remark;
@property (nonatomic, copy) NSString<Optional> *pickup_province;
@property (nonatomic, copy) NSString<Optional> *pickup_city;
@property (nonatomic, copy) NSString<Optional> *pickup_region;
@property (nonatomic, copy) NSString<Optional> *pickup_street;
@property (nonatomic, copy) NSString<Optional> *pickup_address;
@property (nonatomic, strong) NSMutableArray<Optional> *pickup_location;
@property (nonatomic, copy) NSString<Optional> *pickup_start_time;
@property (nonatomic, copy) NSString<Optional> *pickup_start_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_end_time;
@property (nonatomic, copy) NSString<Optional> *pickup_end_time_format;
@property (nonatomic, copy) NSString<Optional> *pickup_name;
@property (nonatomic, copy) NSString<Optional> *pickup_mobile_phone;
@property (nonatomic, copy) NSString<Optional> *pickup_tel_phone;
@property (nonatomic, copy) NSString<Optional> *delivery_province;
@property (nonatomic, copy) NSString<Optional> *delivery_city;
@property (nonatomic, copy) NSString<Optional> *delivery_region;
@property (nonatomic, copy) NSString<Optional> *delivery_street;
@property (nonatomic, copy) NSString<Optional> *delivery_address;
@property (nonatomic, strong) NSMutableArray<Optional> *delivery_location;
@property (nonatomic, copy) NSString<Optional> *delivery_start_time;
@property (nonatomic, copy) NSString<Optional> *delivery_start_time_format;
@property (nonatomic, copy) NSString<Optional> *delivery_end_time;
@property (nonatomic, copy) NSString<Optional> *delivery_end_time_format;
@property (nonatomic, copy) NSString<Optional> *delivery_name;
@property (nonatomic, copy) NSString<Optional> *delivery_mobile_phone;

@property (nonatomic, strong) NSMutableArray<Optional,GoodModel> *goods;
@property (nonatomic, strong) NSMutableArray<Optional,GoodModel> *mobile_goods;

@property (nonatomic, strong) NSNumber<Optional> *current_grab_price;
@property (nonatomic, strong) NSNumber<Optional> *highest_protect_price;
@property (nonatomic, strong) NSNumber<Optional> *lowest_protect_price;
@property (nonatomic, strong) NSNumber<Optional> *highest_grab_price;
@property (nonatomic, strong) NSNumber<Optional> *lowest_grab_price;
@property (nonatomic, strong) NSNumber<Optional> *truck_count;
@property (nonatomic, strong) NSNumber<Optional> *auto_close_duration;

@property (nonatomic, strong) NSNumber<Optional> *payment_top_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_top_cash_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_top_card_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_tail_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_tail_cash_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_tail_card_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_last_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_last_cash_rate;
@property (nonatomic, strong) NSNumber<Optional> *payment_last_card_rate;

@property (nonatomic, strong) NSArray<Optional> *pickup_region_location;
@property (nonatomic, strong) NSArray<Optional> *delivery_region_location;
@property (nonatomic, strong) ExecuteDriverModel<Optional> *execute_driver;

@property (nonatomic, copy) WinnerModel<Optional> *driver_winner;
@property (nonatomic, strong) NSMutableArray<Optional,TenderRecordModel> *tender_records;
@property (nonatomic, strong) NSNumber<Optional> *winner_price;

@property (nonatomic, strong) NSNumber<Optional> *lowest_tons_count;


- (NSInteger)getBindderPrice;
- (NSInteger)getBindderTonPrice;
- (BOOL)isAlreadyBind;
@end
