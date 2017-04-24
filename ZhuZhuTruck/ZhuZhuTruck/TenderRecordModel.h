//
//  TenderRecordModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/2/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TenderRecordModel <NSObject>

@end

@interface TenderRecordModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *driver;
@property (nonatomic, strong) NSNumber<Optional> *price;
@property (nonatomic, strong) NSNumber<Optional> *price_per_ton;
@end
