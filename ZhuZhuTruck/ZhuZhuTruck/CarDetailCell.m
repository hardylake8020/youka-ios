//
//  CarDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CarDetailCell.h"

@interface CarDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end

@implementation CarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithDataDict:(NSDictionary *)dataDict{
    //    self.iconImageView.image = [UIImage imageNamed:[dataDict stringForKey:@"imageName"]];
    self.titleLabel.text = [dataDict objectForKey:@"title"];
    self.subTitleLabel.text = [dataDict objectForKey:@"subTitle"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
