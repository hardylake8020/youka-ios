//
//  CCButton.h
//  ZhengChe
//
//  Created by CongCong on 16/9/10.
//  Copyright © 2016年 CongCong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CCButton : NSObject
+(UIButton *)ButtonWithFrame:(CGRect)frame cornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action;
+(UIButton *)ButtonCornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleSeletedColor:(UIColor*)titleSeletedColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage seletedImage:(UIImage *)seletedImage target:(id)target action:(SEL)action;
+(UIButton *)ButtonCornerradius:(CGFloat )radius normalBackGrondImage:(UIImage *)normalImage heighLightImage:(UIImage *)heighLightedImage target:(id)target action:(SEL)action;
+ (UIButton *)backButtonWithtarget:(id)target action:(SEL)action;
@end
