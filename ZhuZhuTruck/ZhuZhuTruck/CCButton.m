//
//  CCButton.m
//  ZhengChe
//
//  Created by CongCong on 16/9/10.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCButton.h"
#import "NSString+FontAwesome.h"
#import "MarginLabel.h"
#import "UIColor+CustomColors.h"
@implementation CCButton
+(UIButton *)ButtonWithFrame:(CGRect)frame cornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)ButtonCornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleSeletedColor:(UIColor*)titleSeletedColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage seletedImage:(UIImage *)seletedImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = [UIColor customGrayColor].CGColor;
    button.layer.borderWidth = 1;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleSeletedColor forState:UIControlStateSelected];
    button.titleLabel.font = titleFont;
    if (normalImage) {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    [button setBackgroundImage:seletedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)ButtonCornerradius:(CGFloat )radius normalBackGrondImage:(UIImage *)normalImage heighLightImage:(UIImage *)heighLightedImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = [UIColor customGrayColor].CGColor;
    button.layer.borderWidth = 1;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:heighLightedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)backButtonWithtarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 20, 60, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,15, 44)];
    [backLabel setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
    UILabel *backTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 45, 44)];
    backTextLabel.textColor = [UIColor whiteColor];
    backTextLabel.text = @"返回";
    [button addSubview:backLabel];
    [button addSubview:backTextLabel];
    return button;
}

@end
