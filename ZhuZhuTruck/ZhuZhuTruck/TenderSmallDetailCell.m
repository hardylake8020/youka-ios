//
//  TenderSmallDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/29.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderSmallDetailCell.h"
#import "Constants.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"
@interface TenderSmallDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineVIew;
@end

@implementation TenderSmallDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithModel:(TenderDetailCellModel*)model{
    self.titleLabel.text = model.title;
    self.subTitleLabel.textColor = UIColorFromRGB(0x333333);
    self.bottomLineVIew.backgroundColor = UIColorFromRGB(0xdddddd);
    self.bottomLineVIew.frame = CGRectMake(0, model.cellHight-0.5, SYSTEM_WIDTH, 0.5);
    if ([model.subTitle isEmpty]) {
        self.subTitleLabel.text = @"未填写";
    }else{
        self.subTitleLabel.text = model.subTitle;
        if (model.isPhone) {
            self.subTitleLabel.textColor = [UIColor customBlueColor];
        }
    }
    if (model.isLight) {
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        self.subTitleLabel.font = [UIFont systemFontOfSize:13];
        
        self.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    if (model.noBottomLine) {
        self.bottomLineVIew.hidden = YES;
    }else{
        self.bottomLineVIew.hidden = NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
