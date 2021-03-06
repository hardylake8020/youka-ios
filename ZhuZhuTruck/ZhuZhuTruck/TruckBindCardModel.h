//
//  TruckBindCardModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/25.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  TruckBindCardModel<NSObject>
@end

@interface TruckBindCardModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic, copy) NSString<Optional> *owner;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *truck_number;
@end
