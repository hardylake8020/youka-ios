//
//  UIColor+CustomColors.m
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customGrayColor
{
    return ColorFromRGB(0xdddddd);
}
+ (UIColor *)naviBlackColor{
    return ColorFromRGB(0x262C37);
}
+ (UIColor *)customRedColor
{
    return ColorFromRGB(0xf3455a);
}
+ (UIColor *)customPinkColor
{
    return ColorFromRGB(0xfeebea);
}
+ (UIColor *)customYellowColor
{
    return ColorFromRGB(0xffcf00);
}

+ (UIColor *)customGreenColor
{
    return ColorFromRGB(0x2DBF00);
}

+ (UIColor *)customBlueColor
{
    return ColorFromRGB(0x4c8bf4);
}

+ (UIColor *)naviBarColor
{
     return ColorFromRGB(0x4285f4);
}
+ (UIColor *)textDarkColor
{
    return ColorFromRGB(0x212121);
}
+ (UIColor *)buttonGreenColor
{
    return ColorFromRGB(0x3ebf43);
}
+ (UIColor*)colorWithRGB:(NSInteger)rgb{
    return ColorFromRGB(rgb);
}
+ (UIColor *)grayTextColor{
    return ColorFromRGB(0x999999);
}
#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
