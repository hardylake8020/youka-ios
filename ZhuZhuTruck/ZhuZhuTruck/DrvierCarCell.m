//
//  DrvierCarCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DrvierCarCell.h"
#import "Constants.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>
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
    self.carImageView.image = [UIImage imageNamed:@"truck_car"];
    self.carNumberLabel.text = (!model.truck_number||[model.truck_number isEmpty])?@"未设置":model.truck_number;
    self.carDetailLabel.text = [NSString stringWithFormat:@"车辆描述    %@",(!model.truck_type||[model.truck_type isEmpty])?@"未设置":model.truck_type];
    self.driverNameLabel.text = [NSString stringWithFormat:@"车辆司机    %@",(![model.driver_name isEmpty]&&model.driver_name)?model.driver_name:@"未设置"] ;
    self.contactLabel.text =[NSString stringWithFormat:@"联系手机    %@",model.driver_number];
}




- (void)showSeletedTruckCellWithModel:(TruckModel *)model{
    self.carImageView.image = [UIImage imageNamed:@"truck_car"];
    self.carNumberLabel.text = (!model.truck_number||[model.truck_number isEmpty])?@"未设置":model.truck_number;
    self.carDetailLabel.text = [NSString stringWithFormat:@"车辆描述    %@",(!model.truck_type||[model.truck_type isEmpty])?@"未设置":model.truck_type];
    self.driverNameLabel.text = [NSString stringWithFormat:@"车辆司机    %@",(![model.driver_name isEmpty]&&model.driver_name)?model.driver_name:@"未设置"] ;
    self.contactLabel.text =[NSString stringWithFormat:@"联系手机    %@",model.driver_number];
    if (model.isSeleted.boolValue) {
        self.seletedImageView.image = [UIImage imageNamed:@"seleted"];
    }else{
        self.seletedImageView.image = [UIImage imageNamed:@"un_seleted"];
    }

}

- (void)showDriverCellWithDriverModel:(DriverModel*)model{
    
    self.carNumberLabel.text = (!model.truck_number||[model.truck_number isEmpty])?@"未设置":model.truck_number;
    self.carDetailLabel.text = [NSString stringWithFormat:@"车辆描述    %@",(!model.truck_type||[model.truck_type isEmpty])?@"未设置":model.truck_type];
    self.driverNameLabel.text = [NSString stringWithFormat:@"车辆司机    %@",(![model.nickname isEmpty]&&model.nickname)?model.nickname:@"未设置"] ;
    self.contactLabel.text =[NSString stringWithFormat:@"联系手机    %@",model.username];
    
    if ([model.photo isEqualToString:@""]) {
        model.photo = nil;
    }
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,model.photo]] placeholderImage:[UIImage imageNamed:@"ic_head"] options:SDWebImageLowPriority|SDWebImageProgressiveDownload];
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
