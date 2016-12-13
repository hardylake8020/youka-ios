//
//  WalletCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WalletCell.h"
#import "Constants.h"
#import "NSDictionary+Tool.h"
@interface WalletCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation WalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithDataDict:(NSDictionary *)dataDict{
//    self.iconImageView.image = [UIImage imageNamed:[dataDict stringForKey:@"imageName"]];
    self.titleLabel.text = [dataDict objectForKey:@"titleName"];
    self.bottomLineView.frame = CGRectMake(0, 43.5, SYSTEM_WIDTH, 0.5);
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
