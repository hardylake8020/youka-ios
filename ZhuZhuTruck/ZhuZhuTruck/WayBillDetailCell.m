//
//  WayBillDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WayBillDetailCell.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"
@interface WayBillDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation WayBillDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithModel:(WaybillDetailCellModel *)model{
    self.titleLabel.text = model.title;
    self.subTitleLabel.textColor = [UIColor blackColor];
    if ([model.subTitle isEmpty]) {
        self.subTitleLabel.text = @"未填写";
    }else{
        self.subTitleLabel.text = model.subTitle;
        if (model.isPhone) {
            self.subTitleLabel.textColor = [UIColor customBlueColor];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
