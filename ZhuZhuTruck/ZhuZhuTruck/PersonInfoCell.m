//
//  PersonInfoCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/16.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PersonInfoCell.h"
#import "CCFile.h"
#import "Constants.h"

#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>
#import "NSDictionary+Tool.h"
#import "UIColor+CustomColors.h"

@implementation PersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showCellWithPhotoDict:(NSDictionary *)photoDict{

    self.titleLabel.text = [photoDict stringForKey:@"title"];
    if (![[photoDict stringForKey:@"photoname"] isEmpty]) {
        self.stateLabel.text = @"已设置";
        self.stateLabel.textColor = [UIColor grayColor];
    }else{
        self.stateLabel.text = @"未设置";
        self.stateLabel.textColor = [UIColor customRedColor];
    }
}

- (void)showCellWithPerInfoModel:(PersonInfoModel *)model{
    self.titleLabel.text = model.title;
    self.photoImage.hidden = YES;
    self.stateLabel.hidden = NO;
    if (model.isChange) {
        self.stateLabel.text = @"已修改";
        self.stateLabel.textColor = [UIColor customGreenColor];
    }else{
        if (model.photoName&&![model.photoName isEmpty]) {
            if (model.isText) {
                self.stateLabel.text = model.photoName;
                self.stateLabel.textColor = [UIColor grayColor];
            }else{
                self.photoImage.hidden = NO;
                self.stateLabel.hidden = YES;
                
                NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", model.photoName]);
                // NSLog(@"filepath: %@",filePath);
                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                
                if (!imageData||imageData.length==0) {
                    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,model.photoName]] placeholderImage:[UIImage imageNamed:@"noimage"] options:SDWebImageLowPriority|SDWebImageProgressiveDownload];
                }else{
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.photoImage.image = image;
                }
                
            }
        }else{
            self.stateLabel.text = @"未设置";
            self.stateLabel.textColor = [UIColor customRedColor];
        }
    }
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
