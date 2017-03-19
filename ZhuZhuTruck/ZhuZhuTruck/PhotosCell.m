//
//  PhotosCell.m
//  ZhengChe
//
//  Created by CongCong on 16/9/18.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "PhotosCell.h"
#import "CCColor.h"
#import "Constants.h"
#import "CCFile.h"
#import "NSString+FontAwesome.h"
#import "NSString+Tool.h"
@interface PhotosCell (){
    UILabel  *textLabel;
    UIImageView *imageView;
    UILabel *titleLabel;
}
@end

@implementation PhotosCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel  *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.1, self.frame.size.width, self.frame.size.height*0.6)];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        [iconLabel setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
        iconLabel.text = [NSString fontAwesomeIconStringForEnum:FACamera];
        [self addSubview:iconLabel];
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.5, self.frame.size.width, self.frame.size.height*0.3)];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = iconLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        [self addSubview:textLabel];
        
        imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
        
//        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 16)];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont systemFontOfSize:12];
//        titleLabel.textAlignment  = NSTextAlignmentCenter;
//        [imageView addSubview:titleLabel];
        self.clipsToBounds = YES;
        self.contentView.layer.borderWidth = 0.3;
        self.contentView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title andPhotoName:(NSString *)photoName
{
    if ([photoName isEqualToString:@""]) {
        textLabel.text = title;
        imageView.hidden = YES;
    }
    else
    {
        NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", photoName]);
        // NSLog(@"filepath: %@",filePath);
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        imageView.image = image;
        imageView.hidden = NO;
//        if ([title hasSuffix:@"(可选)"]) {
//            titleLabel.backgroundColor = UIColorFromRGB(0x3ebf43);
//        }
//        else if([title isEqualToString:@"货损"]){
//            titleLabel.backgroundColor = UIColorFromRGB(0xff6666);
//        }
//        else
//        {
//            titleLabel.backgroundColor = UIColorFromRGB(0xffa948);
//        }
//        int Width = [title sizeW:12]+4;
//        titleLabel.text = title;
//        titleLabel.frame = CGRectMake(0, 0, Width, 16);
    }
    [self setNeedsDisplay];
}


@end
