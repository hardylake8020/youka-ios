//
//  CardModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/13.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol CardModel <NSObject>

@end

@interface CardModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *created;
@property (nonatomic, copy) NSString<Optional> *updated;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic, copy) NSString<Optional> *owner;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *truck_number;

@property (nonatomic, strong) NSNumber<Optional> *isSeleted;
@end
