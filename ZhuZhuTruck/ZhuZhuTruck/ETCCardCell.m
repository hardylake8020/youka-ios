//
//  ETCCardCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ETCCardCell.h"
#import "UIColor+CustomColors.h"
@interface ETCCardCell ()
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImageView;
@end

@implementation ETCCardCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithStatus:(BOOL)status{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customRedColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    if (status) {
        self.carNumberLabel.text = @"沪A88888";
        self.backGroundView.backgroundColor = [UIColor customRedColor];
        self.carNumberLabel.textColor = [UIColor whiteColor];
        self.cardNumberLabel.textColor = [UIColor whiteColor];
        self.cardTipLabel.textColor = [UIColor whiteColor];
    }else{
        self.carNumberLabel.text = @"未启用";
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        self.carNumberLabel.textColor = [UIColor customRedColor];
        self.cardNumberLabel.textColor = [UIColor customRedColor];
        self.cardTipLabel.textColor = [UIColor customRedColor];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showSeletedCellWithStatus:(BOOL)status{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customRedColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    self.carNumberLabel.text = @"未启用";
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.carNumberLabel.textColor = [UIColor customRedColor];
    self.cardNumberLabel.textColor = [UIColor customRedColor];
    self.cardTipLabel.textColor = [UIColor customRedColor];
    
    if (status) {
        self.seletedImageView.image = [UIImage imageNamed:@"seleted"];
    }else{
        self.seletedImageView.image = [UIImage imageNamed:@"un_seleted"];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
       // Configure the view for the selected state
}

@end
