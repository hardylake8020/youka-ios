//
//  TenderCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderCell.h"
#import "UIColor+CustomColors.h"
@interface TenderCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *CompareOrRobView;

@end


@implementation TenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)showCellWithStatus:(BOOL)status{
    if (!status) {
        self.CompareOrRobView.text = @"抢";
        self.CompareOrRobView.backgroundColor = [UIColor customRedColor];
    }else{
        self.CompareOrRobView.text = @"比";
        self.CompareOrRobView.backgroundColor = [UIColor buttonGreenColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
