//
//  TimeLineCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TimeLineCell.h"
#import "CCDate.h"
#import "CCFile.h"
#import "Constants.h"
#import <UIImageView+WebCache.h>
@interface TimeLineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *photoTIpLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

@property (weak, nonatomic) IBOutlet UIView *timeLineView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showEventWithModel:(EventModel *)eventModel{
    if (eventModel.photos.count>0) {
        self.photoTIpLabel.hidden = NO;
        self.photoScrollView.hidden = NO;
        for (UIView *subView in self.photoScrollView.subviews) {
            [subView removeFromSuperview];
        }
        CGFloat imageHight = self.photoScrollView.frame.size.height;
        self.photoScrollView.contentSize = CGSizeMake(imageHight*eventModel.photos.count, imageHight);
        for (int i=0; i<eventModel.photos.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*imageHight+3*i, 0, imageHight, imageHight)];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            
            PhotoModel *photoModel  = [eventModel.photos objectAtIndex:i];
            NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", photoModel.url]);
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            if (!imageData||imageData.length==0) {
                NSString *urlString = [NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,photoModel.url];
                CCLog(@"----->%@",urlString);
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"noimage"]];
            }else{
                UIImage *image = [UIImage imageWithData:imageData];
                imageView.image = image;
            }
            [self.photoScrollView addSubview:imageView];
        }

    }else{
        self.photoTIpLabel.hidden = YES;
        self.photoScrollView.hidden = YES;
    }
    
    self.eventImageView.image = [UIImage imageNamed:@"halfway_event"];
    if ([eventModel.type isEqualToString:@"confirm"]) {
        self.eventImageView.image = [UIImage imageNamed:@"confirm_succeed"];
        self.titleLabel.text = @"发车启动";
    }else if ([eventModel.type isEqualToString:@"pickup"]) {
        self.titleLabel.text = @"提货成功";
        self.eventImageView.image = [UIImage imageNamed:@"pickup_succeed"];
    }else if ([eventModel.type isEqualToString:@"delivery"]) {
        self.titleLabel.text = @"交货成功";
        self.eventImageView.image = [UIImage imageNamed:@"develiy_succeed"];
    }else if ([eventModel.type isEqualToString:@"pickupSign"]) {
        self.titleLabel.text = @"提货进场";
    }else if ([eventModel.type isEqualToString:@"deliverySign"]) {
        self.titleLabel.text = @"交货进场";
    }else if ([eventModel.type isEqualToString:@"halfway"]) {
        self.titleLabel.text = @"中途事件";
    }
    self.dataLabel.text = dateStringWithDateAndFormart(eventModel.time, @"yyyy-MM-dd");
    self.timeLabel.text = dateStringWithDateAndFormart(eventModel.time, @"hh:mm:ss");
    self.addressLabel.text = eventModel.address;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
