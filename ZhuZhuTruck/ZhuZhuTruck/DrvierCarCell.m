//
//  DrvierCarCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DrvierCarCell.h"

@interface DrvierCarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImageView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;

@end

@implementation DrvierCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithStatus:(BOOL)status{
    if (status) {
        self.seletedImageView.image = [UIImage imageNamed:@"seleted"];
    }else{
        self.seletedImageView.image = [UIImage imageNamed:@"un_seleted"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
