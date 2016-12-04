//
//  TenderSucceedCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderSucceedCell.h"

@interface TenderSucceedCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@end

@implementation TenderSucceedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
