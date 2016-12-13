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
@property (nonatomic, copy) NSString<Optional> *truck_number;
@property (nonatomic, copy) NSString<Optional> *truck_type;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, strong) NSMutableArray<Optional> *location;
@property (nonatomic, strong) CardModel<Optional> *card;

@end
