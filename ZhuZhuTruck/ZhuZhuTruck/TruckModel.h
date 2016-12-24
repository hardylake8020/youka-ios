//
//  TruckModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/13.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "CardModel.h"
@interface TruckModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *truck_number;
@property (nonatomic, copy) NSString<Optional> *truck_type;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) NSString<Optional> *driver;
@property (nonatomic, copy) NSString<Optional> *driver_name;
@property (nonatomic, copy) NSString<Optional> *driver_number;
@property (nonatomic, copy) NSString<Optional> *card_number;
@property (nonatomic, strong) NSMutableArray<Optional> *location;
@property (nonatomic, strong) CardModel<Optional> *card;
@property (nonatomic, strong) NSNumber<Optional> *isSeleted;
@end
