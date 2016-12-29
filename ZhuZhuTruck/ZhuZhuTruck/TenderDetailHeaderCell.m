//
//  TenderDetailHeaderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailHeaderCell.h"
#import "Constants.h"
#import "UIColor+CustomColors.h"

@interface TenderDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *fromProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *toProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineVIew;
@property (weak, nonatomic) IBOutlet UIView *topLine;
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
    
    self.bottomLineVIew.backgroundColor = [UIColor customGrayColor];
    self.bottomLineVIew.frame = CGRectMake(0, 79.5, SYSTEM_WIDTH, 0.5);
    
    self.topLine.frame = CGRectMake(0, 0, SYSTEM_WIDTH, 0.5);
    self.topLine.backgroundColor = [UIColor customGrayColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
