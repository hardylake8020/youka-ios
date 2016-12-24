//
//  CarDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CarDetailCell.h"
#import "NSString+Tool.h"
@interface CarDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end

@implementation CarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithCellModel:(TruckDetailCellModel *)model{
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = ![model.subTitle isEmpty]?model.subTitle:@"未知";
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
