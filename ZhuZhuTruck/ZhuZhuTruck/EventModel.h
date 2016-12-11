//
//  EventModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PhotoModel.h"
@protocol EventModel <NSObject>
@end

@interface EventModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *descrip;
@property (nonatomic, copy) NSString<Optional> *voice_file;
@property (nonatomic, copy) NSString<Optional> *address;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, strong) NSNumber<Optional> *delivery_by_qrcode;
@property (nonatomic, strong) NSMutableArray<Optional,PhotoModel> *photos;
@end
