//
//  CarDetailCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CarDetailCell.h"
#import "Constants.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>
@interface CarDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@end

@implementation CarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithCellModel:(TruckDetailCellModel *)model{
    self.titleLabel.text = model.title;
    if (model.isImage&&![model.subTitle isEmpty]) {
        self.subTitleLabel.hidden = YES;
        self.photoImage.hidden = NO;
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,model.subTitle]] placeholderImage:[UIImage imageNamed:@"noimage"] options:SDWebImageLowPriority|SDWebImageProgressiveDownload];
    }else{
        self.subTitleLabel.hidden = NO;
        self.photoImage.hidden = YES;
        self.subTitleLabel.text = (![model.subTitle isEmpty]&&model.subTitle)?model.subTitle:@"未设置";
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
