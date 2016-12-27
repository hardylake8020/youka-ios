//
//  TenderDetailHeaderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailHeaderCell.h"
#import "Constants.h"

@interface TenderDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *fromProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *toProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineVIew;
@end

@implementation TenderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showTenderHeaderCellWithModel:(TenderModel *)model{
    self.fromProvinceLabel.text = model.pickup_province;
    self.fromCityLabel.text = model.pickup_city;
    self.toProvinceLabel.text = model.delivery_province;
    self.toCityLabel.text = model.delivery_city;
    self.bottomLineVIew.backgroundColor = UIColorFromRGB(0xdddddd);
    self.bottomLineVIew.frame = CGRectMake(0, 78.5, SYSTEM_WIDTH, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
