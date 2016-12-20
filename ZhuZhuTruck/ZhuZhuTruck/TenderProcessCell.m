//
//  TenderProcessCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderProcessCell.h"
#import "CCDate.h"
#import "UIColor+CustomColors.h"

@interface TenderProcessCell ()
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TenderProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showTenderCellWithTenderModel:(TenderModel *)model{
    
    self.centerTipLabel.text = @"";
    if ([model.tender_type isEqualToString:@"grab"]) {
        if ([model.status isEqualToString:@"unAssigned"]) {
            self.statusLabel.text = @"抢标成功";
            self.centerTipLabel.text = @"待分配车辆";
            self.statusLabel.textColor = [UIColor customGreenColor];
        }else{
            self.statusLabel.text = @"抢标失败";
            self.statusLabel.textColor = [UIColor customRedColor];
        }
    }else{
        if ([model.status isEqualToString:@"unAssigned"]) {
            self.statusLabel.text = @"比价中标成功";
            self.centerTipLabel.text = @"待分配车辆";
            self.statusLabel.textColor = [UIColor customGreenColor];
        }else{
            self.statusLabel.text = @"抢标失败";
            self.statusLabel.textColor = [UIColor customRedColor];
        }
    }
    
    
    
    
    self.fromCityLabel.text = model.pickup_city;
    self.fromDistrictLabel.text = model.pickup_region;
    self.toCityLabel.text = model.delivery_city;
    self.toDistrictLabel.text = model.delivery_region;
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
