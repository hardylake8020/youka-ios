//
//  CarPhotoView.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/25.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CarPhotoView.h"
#import "CCColor.h"
#import "Constants.h"
#import "CCFile.h"
#import "NSString+FontAwesome.h"
#import "NSString+Tool.h"

@interface CarPhotoView (){
    UILabel  *textLabel;
    UIImageView *imageView;
    UILabel *titleLabel;
}

@end

@implementation CarPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel  *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.1, self.frame.size.width, self.frame.size.height*0.8)];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        [iconLabel setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
        iconLabel.text = [NSString fontAwesomeIconStringForEnum:FACamera];
        [self addSubview:iconLabel];
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.5, self.frame.size.width, self.frame.size.height*0.3)];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = iconLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        [self addSubview:textLabel];
        
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:imageView];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    }
    return self;
}

- (void)setTitle:(NSString *)title andPhotoName:(NSString *)photoName
{
    if ([photoName isEqualToString:@""]) {
        textLabel.text = title;
        imageView.hidden = YES;
    }
    else{
        NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", photoName]);
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        imageView.image = image;
        imageView.hidden = NO;
        imageView.image = image;
    }
    [self setNeedsDisplay];
}



@end
