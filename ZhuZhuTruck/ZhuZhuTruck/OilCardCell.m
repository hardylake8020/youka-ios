//
//  OilCardCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "OilCardCell.h"
#import "NSString+Tool.h"
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

- (void)showCardCellWithModel:(CardModel *)model{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customBlueColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    if (![model.truck_number isEmpty]) {
        self.carNumberLabel.text = model.truck_number;
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
    self.cardNumberLabel.text = model.number;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showSeletedCardCellWithModel:(CardModel *)model{
    self.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.backGroundView.layer.borderColor = [UIColor customBlueColor].CGColor;
    self.backGroundView.layer.borderWidth = 0.5;
    self.carNumberLabel.text = @"未启用";
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.carNumberLabel.textColor = [UIColor customBlueColor];
    self.cardNumberLabel.textColor = [UIColor customBlueColor];
    self.cardTipLabel.textColor = [UIColor customBlueColor];
    self.cardNumberLabel.text = model.number;
    if (model.isSeleted.boolValue) {
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
