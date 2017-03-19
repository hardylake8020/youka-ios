//
//  PictureCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/16.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PictureCell.h"
#import "CCColor.h"
#import "Constants.h"
#import "CCFile.h"
#import "NSString+FontAwesome.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>
@interface PictureCell (){
    UIImageView *imageView;
    UILabel *titleLabel;
}
@end

@implementation PictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel  *iconLabel = [[UILabel alloc]initWithFrame:self.bounds];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        [iconLabel setFont:[UIFont fontWithName:@"FontAwesome" size:50]];
        iconLabel.text = [NSString fontAwesomeIconStringForEnum:FAPlus];
        [self addSubview:iconLabel];
        imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
        self.contentView.layer.borderWidth = 0.3;
        self.contentView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setPhotoName:(NSString *)photoName
{
    if ([photoName isEqualToString:@""]) {
        imageView.hidden = YES;
    }
    else{
        NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", photoName]);
        // NSLog(@"filepath: %@",filePath);
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        if (!imageData||imageData.length==0) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@",QN_IMAGE_HEADER,photoName];
            CCLog(@"----->%@",urlString);
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"noimage"]];
            
        }else{
            UIImage *image = [UIImage imageWithData:imageData];
            imageView.image = image;
        }
        imageView.hidden = NO;
        
    }
    [self setNeedsDisplay];
}

@end
