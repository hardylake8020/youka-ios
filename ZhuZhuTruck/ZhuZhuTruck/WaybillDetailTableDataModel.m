//
//  WaybillDetailTableDataModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WaybillDetailTableDataModel.h"
@implementation WaybillDetailTableDataModel
//- (instancetype)initWithModel:(OrderModel*)model
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
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
@end
