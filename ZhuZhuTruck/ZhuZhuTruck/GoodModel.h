//
//  GoodModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GoodModel <NSObject>
@end

@interface GoodModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *unit;
@property (nonatomic, strong) NSNumber<Optional> *count;
@property (nonatomic, copy) NSString<Optional> *unit2;
@property (nonatomic, strong) NSNumber<Optional> *count2;
@property (nonatomic, copy) NSString<Optional> *unit3;
@property (nonatomic, strong) NSNumber<Optional> *count3;
@end
