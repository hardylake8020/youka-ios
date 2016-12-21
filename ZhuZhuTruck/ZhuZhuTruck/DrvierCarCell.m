//
//  DrvierCarCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DrvierCarCell.h"
#import "NSString+Tool.h"
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


- (void)showTruckCellWithModel:(TruckModel *)model{
    
    self.carNumberLabel.text = model.truck_number;
    self.carDetailLabel.text = model.truck_type;
    self.driverNameLabel.text = ![model.driver_name isEmpty]?model.driver_name:@"未填写";
    self.contactLabel.text = model.driver_number;
}

- (void)showSeletedTruckCellWithModel:(TruckModel *)model{
    self.carNumberLabel.text = model.truck_number;
    self.carDetailLabel.text = model.truck_type;
    self.driverNameLabel.text = ![model.driver_name isEmpty]?model.driver_name:@"未填写";
    self.contactLabel.text = model.driver_number;
    if (model.isSeleted.boolValue) {
        self.seletedImageView.image = [UIImage imageNamed:@"seleted"];
    }else{
        self.seletedImageView.image = [UIImage imageNamed:@"un_seleted"];
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
