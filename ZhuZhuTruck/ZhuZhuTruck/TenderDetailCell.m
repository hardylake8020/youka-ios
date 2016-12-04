//
//  TenderDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailCell.h"
#import "Constants.h"
#import "NSString+Tool.h"
@interface TenderDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end

@implementation TenderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithModel:(TenderDetailCellModel*)model{
    self.titleLabel.text = model.title;
    self.subTitleLabel.textColor = [UIColor blackColor];
    if ([model.subTitle isEmpty]) {
        self.subTitleLabel.text = @"未填写";
    }else{
        self.subTitleLabel.text = model.subTitle;
    }
    if (model.isLight) {
        self.subTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        if (model.isPhone) {
            self.subTitleLabel.textColor = [UIColor blueColor];
        }
        self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    
    if (model.noBottomLine) {
        self.separatorInset = UIEdgeInsetsMake(0, SYSTEM_WIDTH, 0, 0);
    }else{
        self.separatorInset = UIEdgeInsetsZero;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
