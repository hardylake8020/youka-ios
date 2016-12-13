//
//  UIColor+CustomColors.h
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
@interface UIColor (CustomColors)
+ (UIColor *)naviBlackColor;
+ (UIColor *)customGrayColor;
+ (UIColor *)customRedColor;
+ (UIColor *)customYellowColor;
+ (UIColor *)customGreenColor;
+ (UIColor *)customBlueColor;
+ (UIColor *)customPinkColor;
+ (UIColor *)naviBarColor;
+ (UIColor *)textDarkColor;
+ (UIColor *)buttonGreenColor;
+ (UIColor *)grayTextColor;
+ (UIColor*)colorWithRGB:(NSInteger)rgb;
@end
