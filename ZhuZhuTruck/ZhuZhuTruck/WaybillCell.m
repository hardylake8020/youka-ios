//
//  WaybillCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WaybillCell.h"
#import "CCDate.h"
#import "NSString+Tool.h"
@interface WaybillCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciverLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end

@implementation WaybillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithOrderModel:(OrderModel*)model{
    self.titleLabel.text = model.order_number;
    self.numberLabel.text = ![model.refer_order_number isEmpty]?model.refer_order_number:@"未填写";
    
    NSMutableString *goodNameSring = [NSMutableString string];
    
    for (int i=0; i<model.goods.count; i++) {
        GoodModel *goodModel = [model.goods objectAtIndex:i];
        if (i!=0) {
            [goodNameSring appendString:@" / "];
        }
        [goodNameSring appendString:goodModel.name];
    }
    self.goodsLabel.text = ![goodNameSring isEmpty]?goodNameSring:@"未填写";
    self.reciverLabel.text = ![model.delivery_contacts.name isEmpty]?model.delivery_contacts.name:@"未填写";
    NSString *startTime;
    NSString *endTime;
    if ([model.status isEqualToString:@"unPickupSigned"]||[model.status isEqualToString:@"unPickuped"]) {
        startTime = dateStringWithDateAndFormart(model.pickup_start_time_format, @"MM月 dd日 hh:mm");
        endTime = dateStringWithDateAndFormart(model.pickup_end_time_format, @"MM月 dd日 hh:mm");
    }else if ([model.status isEqualToString:@"unDeliverySigned"]||[model.status isEqualToString:@"unDeliveried"]) {
        startTime = dateStringWithDateAndFormart(model.delivery_start_time_format, @"MM月 dd日 hh:mm");
        endTime = dateStringWithDateAndFormart(model.delivery_end_time_format, @"MM月 dd日 hh:mm");
    }else if ([model.status isEqualToString:@"completed"]) {
        startTime = dateStringWithDateAndFormart(model.created, @"MM月 dd日 hh:mm");
        endTime = dateStringWithDateAndFormart(model.updated, @"MM月 dd日 hh:mm");
    }

    self.timelabel.text = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    
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
