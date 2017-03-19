//
//  TruckDetailTableDataModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/24.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TruckDetailTableDataModel.h"

#import "NSString+Tool.h"
@implementation TruckDetailTableDataModel

- (instancetype)initWithTruckModel:(TruckModel *)model
{
    self = [super init];
    if (self) {
        [self initTruckDetailWithModel:model];
    }
    return self;
}

- (instancetype)initWithDriverModel:(DriverModel *)driverModel{
    self = [super init];
    if (self) {
        [self initTruckDriverModel:driverModel];
    }
    return self;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)initTruckDetailWithModel:(TruckModel*)truckModel{
    
    NSMutableArray *carArray = [NSMutableArray array];
    NSMutableArray *driverArray = [NSMutableArray array];
    NSMutableArray *statusArray = [NSMutableArray array];
    
    TruckDetailCellModel *model = [[TruckDetailCellModel alloc]init];
    model.title = @"车牌";
    model.subTitle = truckModel.truck_number;
    [carArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"车型";
    model.subTitle = truckModel.truck_type;
    [carArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"卡劵";
    if ([truckModel.card.type isEqualToString:@"etc"]) {
        model.title = @"ETC卡";
    } else if ([truckModel.card.type isEqualToString:@"unEtc"]) {
        model.title = @"油卡";
    }
    model.subTitle = ![truckModel.card_number isEmpty]?truckModel.card_number:@"未绑定";
    [carArray addObject:model];
    
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"司机";
    model.subTitle = truckModel.driver_name;
    [driverArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = truckModel.driver_number;
    [driverArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"状态";
//    model.subTitle = truckModel.truck_number;
    model.subTitle = @"运输中";
    [statusArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"当前位置";
//    model.subTitle = truckModel.truck_number;
    model.subTitle = @"上海浦东";
    [statusArray addObject:model];
    
    [self.dataArray addObject:carArray];
    [self.dataArray addObject:driverArray];
    [self.dataArray addObject:statusArray];
}

- (void)initTruckDriverModel:(DriverModel *)driverModel{
    NSMutableArray *driverArray = [NSMutableArray array];
    
    NSMutableArray *carArray = [NSMutableArray array];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    TruckDetailCellModel *model = [[TruckDetailCellModel alloc]init];
    model.title = @"车牌";
    model.subTitle = driverModel.truck_number;
    [carArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"车型";
    model.subTitle = driverModel.truck_type;
    [carArray addObject:model];
    
//    model = [[TruckDetailCellModel alloc]init];
//    model.title = @"卡劵";
//    if ([truckModel.card.type isEqualToString:@"etc"]) {
//        model.title = @"ETC卡";
//    } else if ([truckModel.card.type isEqualToString:@"unEtc"]) {
//        model.title = @"油卡";
//    }
//    model.subTitle = ![truckModel.card_number isEmpty]?truckModel.card_number:@"未绑定";
//    [carArray addObject:model];
    
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"司机";
    model.subTitle = driverModel.nickname;
    [driverArray addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = driverModel.username;
    [driverArray addObject:model];
    
    
//    model = [[TruckDetailCellModel alloc]init];
//    model.title = @"当前位置";
//    //    model.subTitle = truckModel.truck_number;
//    model.subTitle = @"上海浦东";
//    [driverArray addObject:model];
    
    
    
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"身份证照片";
    model.isImage = YES;
    model.subTitle = driverModel.id_card_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"银行卡照片";
    model.isImage = YES;
    model.subTitle = driverModel.bank_number_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"驾驶证照片";
    model.isImage = YES;
    model.subTitle = driverModel.driving_id_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"行驶证照片";
    model.isImage = YES;
    model.subTitle = driverModel.travel_id_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"装车单照片";
    model.isImage = YES;
    model.subTitle = driverModel.truck_list_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"司机照片";
    model.isImage = YES;
    model.subTitle = driverModel.photo;
    [photos addObject:model];

    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"车辆照片";
    model.isImage = YES;
    model.subTitle = driverModel.truck_photo;
    [photos addObject:model];
    
    model = [[TruckDetailCellModel alloc]init];
    model.title = @"车牌照片";
    model.isImage = YES;
    model.subTitle = driverModel.plate_photo;
    [photos addObject:model];
    
    
   
    
    [self.dataArray addObject:driverArray];
    [self.dataArray addObject:carArray];
    [self.dataArray addObject:photos];
}


@end
