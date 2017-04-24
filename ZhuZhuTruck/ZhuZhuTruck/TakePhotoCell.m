//
//  TakePhotoCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "TakePhotoCell.h"
#import "CCFile.h"
#import "Constants.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>
#import "UIColor+CustomColors.h"
#import "NSString+FontAwesome.h"

@interface TakePhotoCell ()
@property (nonatomic, strong) TakePhotoModel *model;
@end

@implementation TakePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.photoLabel.layer.borderWidth = 0.5;
    self.photoLabel.backgroundColor = ColorFromRGB(0xf5f5f5);
    self.photoLabel.font = [UIFont fontWithName:@"FontAwesome" size:25];
    self.photoLabel.text = [NSString fontAwesomeIconStringForEnum:FACamera];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}
- (void)showPhotoCellWithModel:(TakePhotoModel*)model{
    self.model = model;
    self.titleLabel.text = model.title;
    if (model.photoName&&![model.photoName isEmpty]) {
        self.photoLabel.hidden = YES;
        self.photoImageView.hidden = NO;
        NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", model.photoName]);
        // NSLog(@"filepath: %@",filePath);
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        if (!self.photoImageView||imageData.length==0) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,model.photoName];
            CCLog(@"----->%@",urlString);
            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"noimage"]];
            
        }else{
            UIImage *image = [UIImage imageWithData:imageData];
            self.photoImageView.image = image;
        }
        self.photoImageView.hidden = NO;

    }else{
        self.photoLabel.hidden = NO;
        self.photoImageView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

@end
