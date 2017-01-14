//
//  ExecuteDriverModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/24.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ExecuteDriverModel <NSObject>
@end

@interface ExecuteDriverModel : JSONModel
@property (nonatomic, strong) NSArray<Optional> *current_location;
@end
