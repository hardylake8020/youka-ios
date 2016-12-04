//
//  TenderDetailHeaderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailHeaderCell.h"

@interface TenderDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *fromProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *toProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;

@end

@implementation TenderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
