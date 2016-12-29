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
#import "UIColor+CustomColors.h"
@interface TenderDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineVIew;
@end

@implementation TenderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithModel:(TenderDetailCellModel*)model{
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, model.cellHight/2);
    self.subTitleLabel.center = CGPointMake(self.subTitleLabel.center.x, model.cellHight/2);
    self.titleLabel.text = model.title;
    self.subTitleLabel.textColor = UIColorFromRGB(0x333333);
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
        if (model.upDown==1) {
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, model.cellHight/2+5);
            self.subTitleLabel.center = CGPointMake(self.subTitleLabel.center.x, model.cellHight/2+5);
        }else if(model.upDown == 2){
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, model.cellHight/2-5);
            self.subTitleLabel.center = CGPointMake(self.subTitleLabel.center.x, model.cellHight/2-5);
        }else if (model.upDown==11) {
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, model.cellHight/2+10);
            self.subTitleLabel.center = CGPointMake(self.subTitleLabel.center.x, model.cellHight/2+10);
        }else if(model.upDown == 22){
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, model.cellHight/2-10);
            self.subTitleLabel.center = CGPointMake(self.subTitleLabel.center.x, model.cellHight/2-10);
        }
    }
    if (model.noBottomLine) {
        self.bottomLineVIew.hidden = YES;
    }else{
        self.bottomLineVIew.hidden = NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self performSelector:@selector(deSeletedCell) withObject:nil afterDelay:0.5];
    }
    // Configure the view for the selected state
}

- (void)deSeletedCell{
    [self setSelected:NO];
}

@end
