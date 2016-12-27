//
//  TenderSucceedCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderSucceedCell.h"
#import "CCDate.h"
#import "UIColor+CustomColors.h"

@interface TenderSucceedCell ()

@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@end

@implementation TenderSucceedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showTenderCellWithTenderModel:(TenderModel *)model{
    
    self.fromCityLabel.text = model.pickup_province;
    self.fromDistrictLabel.text = model.pickup_city;
    self.toCityLabel.text = model.delivery_province;
    self.toDistrictLabel.text = model.delivery_city;
    if ([model.tender_type isEqualToString:@"grab"]) {
        self.statusLabel.text = @"抢标成功";
        self.statusLabel.textColor = [UIColor customGreenColor];
    }else{
        self.statusLabel.text = @"比价中标成功";
        self.statusLabel.textColor = [UIColor customGreenColor];
    }
    if ([model.status isEqualToString:@"completed"]) {
        self.centerTipLabel.text = @"已完成";
    }else{
        self.centerTipLabel.text = @"运输中";
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"发布时间  %@", dateStringWithDateAndFormart(model.start_time, @"MM-dd hh:mm")];
    self.goodsDetailLabel.text = [NSString stringWithFormat:@"货物摘要  %@ %@ %@",model.sender_company,@"55方",@"44公里"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self performSelector:@selector(deSeletedCell) withObject:nil afterDelay:0.5];
    }
    // Configure the view for the selected state
}
- (void)deSeletedCell{
    [self setSelected:NO];
}
@end
