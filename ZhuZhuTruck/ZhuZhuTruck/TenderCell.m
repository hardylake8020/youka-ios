//
//  TenderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderCell.h"
#import "CCDate.h"
#import "UIColor+CustomColors.h"
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
        self.compareOrRobImageView.image = [UIImage imageNamed:@"f3455a"];
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
        self.compareOrRobImageView.image = [UIImage imageNamed:@"FF8886"];
        self.priceOrTimeLabel.text = model.current_grab_price.stringValue;
    }else{
        self.CompareOrRobView.text = @"比";
        self.compareOrRobImageView.image = [UIImage imageNamed:@"3ebf43"];
    }

    self.fromCityLabel.text = model.pickup_city;
    self.fromDistrictLabel.text = model.pickup_region;
    self.toCityLabel.text = model.delivery_city;
    self.toDistrictLabel.text = model.delivery_region;
    self.timeLabel.text = [NSString stringWithFormat:@"发布时间  %@", dateStringWithDateAndFormart(model.start_time, @"MM-dd hh:mm")];
    self.goodsDetailLabel.text = [NSString stringWithFormat:@"货物摘要  %@ %@ %@",model.sender_company,@"55方",@"44公里"];
    
}



- (void)deSeletedCell{
    [self setSelected:NO];
}

@end
