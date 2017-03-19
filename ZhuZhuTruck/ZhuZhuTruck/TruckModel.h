//
//  TruckModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/13.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TruckBindCardModel.h"
#import "DriverModel.h"
@interface TruckModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *truck_number;
@property (nonatomic, copy) NSString<Optional> *truck_type;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) DriverModel<Optional> *driver;
@property (nonatomic, copy) NSString<Optional> *driver_name;
@property (nonatomic, copy) NSString<Optional> *driver_number;
@property (nonatomic, copy) NSString<Optional> *card_number;
@property (nonatomic, strong) NSMutableArray<Optional> *location;
@property (nonatomic, strong) TruckBindCardModel<Optional> *card;
@property (nonatomic, strong) NSNumber<Optional> *isSeleted;


//@property (nonatomic, copy) NSString<Optional> *bank_number;
//@property (nonatomic, copy) NSString<Optional> *bank_number_photo;
//@property (nonatomic, copy) NSString<Optional> *device_id;
//@property (nonatomic, copy) NSString<Optional> *device_id_ios;
//@property (nonatomic, copy) NSString<Optional> *driving_id_photo;
//@property (nonatomic, copy) NSString<Optional> *id_card_number;
//@property (nonatomic, copy) NSString<Optional> *nickname;
//@property (nonatomic, copy) NSString<Optional> *operating_permits_photo;
//@property (nonatomic, strong) NSNumber<Optional> *is_signup;
//@property (nonatomic, copy) NSString<Optional> *phone;
//@property (nonatomic, copy) NSString<Optional> *photo;
//@property (nonatomic, copy) NSString<Optional> *plate_number;
//@property (nonatomic, strong) NSMutableArray<Optional> *plate_numbers;
//@property (nonatomic, copy) NSString<Optional> *travel_id_number;
//@property (nonatomic, copy) NSString<Optional> *travel_id_photo;
//@property (nonatomic, copy) NSString<Optional> *truck_list_photo;
//@property (nonatomic, copy) NSString<Optional> *username;

@end
