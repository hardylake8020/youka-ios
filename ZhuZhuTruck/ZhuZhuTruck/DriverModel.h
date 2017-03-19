//
//  DriverModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DriverModel <NSObject>
@end

@interface DriverModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *truck_number;
@property (nonatomic, copy) NSString<Optional> *truck_type;

@property (nonatomic, copy) NSString<Optional> *create_time;
@property (nonatomic, strong) NSMutableArray<Optional> *current_location;
@property (nonatomic, copy) NSString<Optional> *password;
@property (nonatomic, copy) NSString<Optional> *bank_number;
@property (nonatomic, copy) NSString<Optional> *bank_number_photo;
@property (nonatomic, copy) NSString<Optional> *device_id;
@property (nonatomic, copy) NSString<Optional> *device_id_ios;
@property (nonatomic, copy) NSString<Optional> *driving_id_photo;
@property (nonatomic, copy) NSString<Optional> *id_card_number;
@property (nonatomic, copy) NSString<Optional> *nickname;
@property (nonatomic, copy) NSString<Optional> *operating_permits_photo;
@property (nonatomic, strong) NSNumber<Optional> *is_signup;
@property (nonatomic, copy) NSString<Optional> *phone;
@property (nonatomic, copy) NSString<Optional> *photo;
@property (nonatomic, copy) NSString<Optional> *plate_number;
@property (nonatomic, strong) NSMutableArray<Optional> *plate_numbers;
@property (nonatomic, copy) NSString<Optional> *travel_id_number;
@property (nonatomic, copy) NSString<Optional> *travel_id_photo;
@property (nonatomic, copy) NSString<Optional> *truck_list_photo;
@property (nonatomic, copy) NSString<Optional> *username;

@property (nonatomic, copy) NSString<Optional> *truck_photo;
@property (nonatomic, copy) NSString<Optional> *id_card_photo;
@property (nonatomic, copy) NSString<Optional> *plate_photo;


@end
