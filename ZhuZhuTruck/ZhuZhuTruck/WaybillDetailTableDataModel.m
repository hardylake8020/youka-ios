//
//  WaybillDetailTableDataModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WaybillDetailTableDataModel.h"
#import "CCDate.h"
#import "Constants.h"
#import "NSString+Tool.h"
@implementation WaybillDetailTableDataModel
- (instancetype)initWithModel:(OrderModel*)model
{
    self = [super init];
    if (self) {
        [self initGoodsDetailsWithOrderModel:model];
        [self initPickupDetailsWithOrderModel:model];
        [self initDeliveryDetailsWithOrderModel:model];
    }
    return self;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initGoodsDetails];
        [self initPickupDetails];
        [self initDeliveryDetails];
    }
    return self;
}

- (void)initGoodsDetails{
    NSMutableArray *goodDetailsArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"运单号";
    model.subTitle = @"PVKLDFHKJH11110";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"参考单号";
    model.subTitle = @"850938085034805839";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"货物";
    model.subTitle = @"阿尔卑斯480支混装（KA）";
    [goodDetailsArray addObject:model];
    
    for (int i=0; i<3; i++) {
        model = [[WaybillDetailCellModel alloc]init];
        model.title = @"";
        model.subTitle = [NSString stringWithFormat:@"%d箱/ %d千克/ %d立方",i+1,(i+1)*10,(i+1)*2];
        [goodDetailsArray addObject:model];
    }
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"总计";
    model.subTitle = [NSString stringWithFormat:@"%d箱/ %d千克/ %d立方",10,100,20];
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"备注";
    model.subTitle = @"轻拿轻放";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"发货方";
    model.subTitle = @"不凡帝";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"收货方";
    model.subTitle = @"天天好食品";
    [goodDetailsArray addObject:model];
    
    [self.dataArray addObject:goodDetailsArray];
    
}
- (void)initPickupDetails{
    NSMutableArray *pickupArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"提货地址";
    model.subTitle = @"重庆第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [pickupArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"联系人";
    model.subTitle = @"向琼兰";
    [pickupArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = @"198345085438";
    model.isPhone = YES;
    [pickupArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"固话";
    model.subTitle = @"4004598789";
    model.isPhone = YES;
    [pickupArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"提货时间";
    model.subTitle = @"08月17日 16:00 ~ 08月18日 16:00";
    [pickupArray addObject:model];
    
    
    
    
    [self.dataArray addObject:pickupArray];
}
- (void)initDeliveryDetails{
    NSMutableArray *deliveryArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"交货地址";
    model.subTitle = @"成都第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [deliveryArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"联系人";
    model.subTitle = @"俞飞鸿";
    [deliveryArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = @"";
    model.isPhone = YES;
    [deliveryArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"固话";
    model.subTitle = @"4004598789";
    model.isPhone = YES;
    [deliveryArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"交货时间";
    model.subTitle = @"08月18日 16:00 ~ 08月19日 16:00";
    [deliveryArray addObject:model];
    
    
    [self.dataArray addObject:deliveryArray];
}
- (void)initGoodsDetailsWithOrderModel:(OrderModel*)orderModel{
    NSMutableArray *goodDetailsArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"运单号";
    model.subTitle = orderModel.order_number;
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"参考单号";
    model.subTitle = ![orderModel.refer_order_number isEmpty]?orderModel.refer_order_number:@"未填写";
    [goodDetailsArray addObject:model];
    
    
//    NSMutableString *goodNameSring = [NSMutableString string];
//    
//    for (int i=0; i<orderModel.goods.count; i++) {
//        GoodModel *goodModel = [orderModel.goods objectAtIndex:i];
//        if (i!=0) {
//            [goodNameSring appendString:@" / "];
//        }
//        [goodNameSring appendString:goodModel.name];
//    }
//
//    
//    model = [[WaybillDetailCellModel alloc]init];
//    model.title = @"货物";
//    model.subTitle = [goodNameSring isEmpty]?@"未填写":@"  ";
//    [goodDetailsArray addObject:model];
//    
//    if (![goodNameSring isEmpty]) {
//        int totalCount1 = 0;
//        int totalCount2 = 0;
//        int totalCount3 = 0;
//        for (int i=0; i<orderModel.goods.count; i++) {
//            GoodModel *goodModel = [orderModel.goods objectAtIndex:i];
//            model = [[WaybillDetailCellModel alloc]init];
//            model.title = goodModel.name;
//            NSMutableString * titleString  = [NSMutableString string];
//            
//            if (goodModel.count.integerValue) {
//                [titleString appendFormat:@"%d%@",goodModel.count.intValue,goodModel.unit];
//            }else{
//                [titleString appendFormat:@"未知件数"];
//            }
//            if (goodModel.count2.integerValue) {
//                [titleString appendFormat:@"/ %d%@",goodModel.count2.intValue,goodModel.unit2];
//            }
//            if (goodModel.count3.integerValue) {
//                [titleString appendFormat:@"/ %d%@",goodModel.count3.intValue,goodModel.unit3];
//            }
//            model.subTitle = titleString;
//            [goodDetailsArray addObject:model];
//            totalCount1 += goodModel.count.intValue;
//            totalCount2 += goodModel.count2.intValue;
//            totalCount3 += goodModel.count3.intValue;
//        }
        
//        model = [[WaybillDetailCellModel alloc]init];
//        model.title = @"总计";
//        model.subTitle = [NSString stringWithFormat:@"%d%@/ %d%@/ %d%@",totalCount1, orderModel.count_unit, totalCount2, orderModel.weight_unit, totalCount3, orderModel.volume_unit];
//        [goodDetailsArray addObject:model];
//    }else{
//         
//    }
    
    int totalCount1 = 0;
    int totalCount2 = 0;
    int totalCount3 = 0;
    for (int i=0; i<orderModel.goods.count; i++) {
        GoodModel *goodModel = [orderModel.goods objectAtIndex:i];
        model = [[WaybillDetailCellModel alloc]init];
        model.title = ![goodModel.name isEmpty]?goodModel.name:@"未知货物";
        NSMutableString * titleString  = [NSMutableString string];
        
        if (goodModel.count.integerValue) {
            [titleString appendFormat:@"%d%@",goodModel.count.intValue,goodModel.unit];
        }else{
            [titleString appendFormat:@"未知件数"];
        }
        if (goodModel.count2.integerValue) {
            [titleString appendFormat:@"/ %d%@",goodModel.count2.intValue,goodModel.unit2];
        }
        if (goodModel.count3.integerValue) {
            [titleString appendFormat:@"/ %d%@",goodModel.count3.intValue,goodModel.unit3];
        }
        model.subTitle = titleString;
        [goodDetailsArray addObject:model];
        totalCount1 += goodModel.count.intValue;
        totalCount2 += goodModel.count2.intValue;
        totalCount3 += goodModel.count3.intValue;
    }

    
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"备注";
    model.subTitle = ![orderModel.descrip isEmpty]?orderModel.descrip:@"未填写";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"发货方";
    model.subTitle = ![orderModel.sender_name isEmpty]?orderModel.sender_name:@"未填写";
    [goodDetailsArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"收货方";
    model.subTitle = ![orderModel.receiver_name isEmpty]?orderModel.receiver_name:@"未填写";
    [goodDetailsArray addObject:model];
    
    [self.dataArray addObject:goodDetailsArray];
    
}
- (void)initPickupDetailsWithOrderModel:(OrderModel*)orderModel{
    NSMutableArray *pickupArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"提货地址";
    model.subTitle = ![orderModel.pickup_contacts.address isEmpty]?orderModel.pickup_contacts.address:@"未填写";
    [pickupArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"联系人";
    model.subTitle = ![orderModel.pickup_contacts.name isEmpty]?orderModel.pickup_contacts.name:@"未填写";
    [pickupArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = ![orderModel.pickup_contacts.mobile_phone isEmpty]?orderModel.pickup_contacts.mobile_phone:@"未填写";
    model.isPhone = ![orderModel.pickup_contacts.mobile_phone isEmpty];
    [pickupArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"固话";
    model.subTitle = ![orderModel.pickup_contacts.phone isEmpty]?orderModel.pickup_contacts.phone:@"未填写";
    model.isPhone = ![orderModel.pickup_contacts.phone isEmpty];
    [pickupArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"提货时间";
    NSString *startTime = dateStringWithDateAndFormart(orderModel.pickup_start_time_format, @"MM月 dd日 hh:mm");
    NSString *endTime = dateStringWithDateAndFormart(orderModel.pickup_end_time_format, @"MM月 dd日 hh:mm");
    model.subTitle = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    [pickupArray addObject:model];
    [self.dataArray addObject:pickupArray];
}
- (void)initDeliveryDetailsWithOrderModel:(OrderModel*)orderModel{
    NSMutableArray *deliveryArray = [NSMutableArray array];
    WaybillDetailCellModel *model = [[WaybillDetailCellModel alloc]init];
    model.title = @"交货地址";
    model.subTitle = ![orderModel.delivery_contacts.address isEmpty]?orderModel.delivery_contacts.address:@"未填写";
    [deliveryArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"联系人";
    model.subTitle = ![orderModel.delivery_contacts.name isEmpty]?orderModel.delivery_contacts.name:@"未填写";
    [deliveryArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"手机";
    model.subTitle = ![orderModel.delivery_contacts.mobile_phone isEmpty]?orderModel.delivery_contacts.mobile_phone:@"未填写";
    model.isPhone = ![orderModel.delivery_contacts.mobile_phone isEmpty];
    [deliveryArray addObject:model];
    
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"固话";
    model.subTitle = ![orderModel.delivery_contacts.phone isEmpty]?orderModel.delivery_contacts.phone:@"未填写";
    model.isPhone = ![orderModel.delivery_contacts.phone isEmpty];
    [deliveryArray addObject:model];
    
    model = [[WaybillDetailCellModel alloc]init];
    model.title = @"交货时间";
    NSString *startTime = dateStringWithDateAndFormart(orderModel.delivery_start_time_format, @"MM月 dd日 hh:mm");
    NSString *endTime = dateStringWithDateAndFormart(orderModel.delivery_end_time_format, @"MM月 dd日 hh:mm");
    model.subTitle = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    [deliveryArray addObject:model];
    
    [self.dataArray addObject:deliveryArray];
}

@end
