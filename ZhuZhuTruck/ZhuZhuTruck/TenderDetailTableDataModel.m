//
//  TenderDetailTableDataModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailTableDataModel.h"
#import "CCDate.h"
#import "Constants.h"
#import "NSString+Tool.h"

@implementation TenderDetailTableDataModel
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithModel:(TenderModel*)model
{
    self = [super init];
    if (self) {
        [self initTenderDetialsWithTenderModel:model];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTenderDetails];
    }
    return self;
}
- (void)initTenderDetails{
    
    TenderDetailCellModel *model = [[TenderDetailCellModel alloc]init];
    model.title = @"车辆要求";
    model.isLight = YES;
    model.subTitle = @"金杯车 1 辆";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"合计";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"12箱/ 200千克/ 4立方米";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"注意事项";
    model.isLight = NO;
    model.subTitle = @"轻拿轻放";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"发标方";
    model.isLight = YES;
    model.subTitle = @"京东";
    [self.dataArray addObject:model];
    
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"联系人";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"王五";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"联系电话";
    model.isLight = NO;
    model.subTitle = @"1324789787";
    model.isPhone = YES;
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货时间";
    model.isLight = YES;
    model.subTitle = @"08月17日 16:00 ~ 08月18日 16:00";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货地址";
    model.isLight = NO;
    model.subTitle = @"成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货时间";
    model.isLight = YES;
    model.subTitle = @"08月17日 16:00 ~ 08月18日 16:00";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货地址";
    model.isLight = NO;
    model.subTitle = @"成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"支付方式";
    model.isLight = YES;
    model.subTitle = @"首付 + 尾款 + 回单";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"首付";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"50% （50% 现金 + 50% 油卡）";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"尾款";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"40% （现金支付）";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"回单";
    model.isLight = NO;
    model.subTitle = @"10% （现金支付）";
    [self.dataArray addObject:model];
    
}

- (void)initTenderDetialsWithTenderModel:(TenderModel *)tenderModel{
    TenderDetailCellModel *model = [[TenderDetailCellModel alloc]init];
    model.title = @"车辆要求";
    model.isLight = YES;
    model.subTitle = [NSString stringWithFormat:@"%@  %ld辆",tenderModel.truck_type, tenderModel.truck_count.integerValue];
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"合计";
    model.isLight = NO;
    model.noBottomLine = YES;
    
    int totalCount1 = 0;
    int totalCount2 = 0;
    int totalCount3 = 0;
    NSString *unit;
    NSString *unit2;
    NSString *unit3;
    
    for (int i=0; i<tenderModel.goods.count; i++) {
        GoodModel *goodModel = [tenderModel.goods objectAtIndex:i];
        totalCount1 += goodModel.count.intValue;
        totalCount2 += goodModel.count2.intValue;
        totalCount3 += goodModel.count3.intValue;
        unit = goodModel.unit;
        unit2 = goodModel.unit2;
        unit3 = goodModel.unit3;
    }

    
    
    model.subTitle = [NSString stringWithFormat:@"%d%@/ %d%@/ %d%@/",totalCount1,unit, totalCount2, unit2, totalCount3, unit3];
    
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"注意事项";
    model.isLight = NO;
    model.subTitle = ![tenderModel.remark isEmpty]?tenderModel.remark:@"未填写";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"发标方";
    model.isLight = YES;
    model.subTitle = tenderModel.sender_company;
    [self.dataArray addObject:model];
    
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货联系人";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = ![tenderModel.pickup_name isEmpty]?tenderModel.pickup_name:@"未填写";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"联系电话";
    model.isLight = NO;
    model.subTitle = ![tenderModel.pickup_tel_phone isEmpty]?tenderModel.pickup_tel_phone:@"未填写";
    model.isPhone = YES;
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货时间";
    model.isLight = YES;
    
    NSString *pickupStartTime = dateStringWithDateAndFormart(tenderModel.pickup_start_time_format, @"MM月 dd日 hh:mm");
    NSString *pickupEndTime = dateStringWithDateAndFormart(tenderModel.pickup_end_time_format, @"MM月 dd日 hh:mm");
    model.subTitle = [NSString stringWithFormat:@"%@ ~ %@", pickupStartTime, pickupEndTime];

    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货地址";
    model.isLight = NO;
    model.subTitle = tenderModel.pickup_address;
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货时间";
    model.isLight = YES;
    NSString *deliveryStartTime = dateStringWithDateAndFormart(tenderModel.delivery_start_time_format, @"MM月 dd日 hh:mm");
    NSString *deliveryEndTime = dateStringWithDateAndFormart(tenderModel.delivery_end_time_format, @"MM月 dd日 hh:mm");
    model.subTitle = [NSString stringWithFormat:@"%@ ~ %@", deliveryStartTime, deliveryEndTime];
    
    
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货地址";
    model.isLight = NO;
    model.subTitle = tenderModel.delivery_address;
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"支付方式";
    model.isLight = YES;
    model.subTitle = @"首付 + 尾款 + 回单";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"首付";
    model.isLight = NO;
    model.noBottomLine = YES;

    if (tenderModel.payment_top_cash_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（现金支付）",tenderModel.payment_top_rate.floatValue*100];
    }else if (tenderModel.payment_top_card_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（油卡支付）",tenderModel.payment_top_rate.floatValue*100];
    }else{
        model.subTitle = [NSString stringWithFormat:@"%.f%%（ %.f%%现金  + %.f%%油卡）",tenderModel.payment_top_rate.floatValue *100, tenderModel.payment_top_cash_rate.floatValue*100,tenderModel.payment_top_card_rate.floatValue*100];
        
    }
    
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"尾款";
    model.isLight = NO;
    model.noBottomLine = YES;
    
    if (tenderModel.payment_tail_cash_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（现金支付）",tenderModel.payment_tail_rate.floatValue*100];
    }else if (tenderModel.payment_tail_card_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（油卡支付）",tenderModel.payment_tail_rate.floatValue*100];
    }else{
        model.subTitle = [NSString stringWithFormat:@"%.f%%（ %.f%%现金  + %.f%%油卡）",tenderModel.payment_tail_rate.floatValue *100, tenderModel.payment_tail_cash_rate.floatValue*100,tenderModel.payment_tail_card_rate.floatValue*100];
        
    }
    
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"回单";
    model.isLight = NO;
    if (tenderModel.payment_last_cash_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（现金支付）",tenderModel.payment_last_rate.floatValue*100];
    }else if (tenderModel.payment_last_card_rate.floatValue==1) {
        model.subTitle = [NSString stringWithFormat:@"%.f%%（油卡支付）",tenderModel.payment_last_rate.floatValue*100];
    }else{
        model.subTitle = [NSString stringWithFormat:@"%.f%%（ %.f%%现金  + %.f%%油卡）",tenderModel.payment_last_rate.floatValue *100, tenderModel.payment_last_cash_rate.floatValue*100,tenderModel.payment_last_card_rate.floatValue*100];
        
    }
    
    [self.dataArray addObject:model];

}

@end
