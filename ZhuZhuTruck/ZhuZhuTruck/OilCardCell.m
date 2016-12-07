//
//  OilCardCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "OilCardCell.h"
#import "UIColor+CustomColors.h"
@interface OilCardCell ()
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImageView;

@end

@implementation OilCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithStatus:(BOOL)status{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customBlueColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    if (status) {
        self.carNumberLabel.text = @"沪A88888";
        self.backGroundView.backgroundColor = [UIColor customBlueColor];
        self.carNumberLabel.textColor = [UIColor whiteColor];
        self.cardNumberLabel.textColor = [UIColor whiteColor];
        self.cardTipLabel.textColor = [UIColor whiteColor];
    }else{
        self.carNumberLabel.text = @"未启用";
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        self.carNumberLabel.textColor = [UIColor customBlueColor];
        self.cardNumberLabel.textColor = [UIColor customBlueColor];
        self.cardTipLabel.textColor = [UIColor customBlueColor];
    }
}
- (void)showSeletedCellWithStatus:(BOOL)status{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customBlueColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    self.carNumberLabel.text = @"未启用";
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.carNumberLabel.textColor = [UIColor customBlueColor];
    self.cardNumberLabel.textColor = [UIColor customBlueColor];
    self.cardTipLabel.textColor = [UIColor customBlueColor];

    if (status) {
        self.seletedImageView.image = [UIImage imageNamed:@"checked_small"];
    }else{
        self.seletedImageView.image = [UIImage imageNamed:@"uncheck_small"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
