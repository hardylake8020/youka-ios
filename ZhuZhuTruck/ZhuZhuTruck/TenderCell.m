//
//  TenderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderCell.h"
#import "CCDate.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface TenderCell ()
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceOrTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *compareOrRobImageView;
@property (weak, nonatomic) IBOutlet UILabel *CompareOrRobView;

@end


@implementation TenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)showCellWithStatus:(BOOL)status{
    if (!status) {
        self.CompareOrRobView.text = @"抢";
        self.compareOrRobImageView.image = [UIImage imageNamed:@"F44C5F"];
    }else{
        self.CompareOrRobView.text = @"比";
        self.compareOrRobImageView.image = [UIImage imageNamed:@"3ebf43"];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self performSelector:@selector(deSeletedCell) withObject:nil afterDelay:0.5];
    }
    // Configure the view for the selected state
}
- (void)showTenderCellWithTenderModel:(TenderModel *)model{
    
    //抢单
    if ([model.tender_type isEqualToString:@"grab"]) {
        self.CompareOrRobView.text = @"抢";
        self.compareOrRobImageView.image = [UIImage imageNamed:@"F44C5F"];
        self.centerTipLabel.text = @"（元）";
        self.priceOrTimeLabel.text = model.current_grab_price.stringValue;
    }else{
        self.CompareOrRobView.text = @"比";
        self.compareOrRobImageView.image = [UIImage imageNamed:@"3ebf43"];
        self.centerTipLabel.text = @"剩余时间";
        self.priceOrTimeLabel.text = [self getTimeLeft:[model.end_time timeRemaining]];
    }

    self.fromCityLabel.text = model.pickup_province;
    self.fromDistrictLabel.text = model.pickup_city;
    self.toCityLabel.text = model.delivery_province;
    self.toDistrictLabel.text = model.delivery_city;
    self.timeLabel.text = [NSString stringWithFormat:@"发布时间  %@", dateStringWithDateAndFormart(model.start_time, @"MM-dd hh:mm")];
    
    self.goodsDetailLabel.text = [NSString stringWithFormat:@"货物摘要  %@ %@ %.2f公里",model.sender_company,[self getGoodNameString:model.goods],[self getDistanceWithStart:model.pickup_region_location andEnd:model.delivery_region_location]];
}

- (NSString *)getTimeLeft:(NSInteger)timeLeft{
    if (timeLeft<0) {
        return @"00:00:00";
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",timeLeft/3600,(timeLeft%3600)/60,timeLeft%60];
}

- (CGFloat)getDistanceWithStart:(NSArray *)start andEnd:(NSArray *)end{

    if (start.count==0||end.count==0) {
        return 0;
    }
    NSNumber *startLat = start[1];
    NSNumber *startLon = start[0];
    NSNumber *endLat   = end[1];
    NSNumber *endLon   = end[0];
    CLLocation *from = [[CLLocation alloc]initWithLatitude:startLat.floatValue longitude:startLon.floatValue];
    CLLocation *to = [[CLLocation alloc]initWithLatitude:endLat.floatValue longitude:endLon.floatValue];
    return [from distanceFromLocation:to]/1000.00;
}


- (NSString *)getGoodNameString:(NSArray *)goods{
    int totalCount1 = 0;
    NSString *uint1;
//    int totalCount2 = 0;
//    int totalCount3 = 0;
    for (int i=0; i<goods.count; i++) {
        GoodModel *goodModel = [goods objectAtIndex:i];
        totalCount1 += goodModel.count.intValue;
        uint1 = goodModel.unit;
//        totalCount2 += goodModel.count2.intValue;
//        totalCount3 += goodModel.count3.intValue;
    }
    
    if (totalCount1==0) {
        return @"未知";
    }
    
    return [NSString stringWithFormat:@"%d %@",totalCount1, uint1];
}


- (void)deSeletedCell{
    [self setSelected:NO];
}

@end
