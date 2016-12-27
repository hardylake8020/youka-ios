//
//  CCNaviHeaderView.m
//  ZhengChe
//
//  Created by CongCong on 16/9/10.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCNaviHeaderView.h"
#import "Constants.h"
#import "UIColor+CustomColors.h"
#import "CCTool.h"
#define LABELHEIGHT 24
#import "CCButton.h"

@interface CCNaviHeaderView()
{
    UILabel* label ;
    CAGradientLayer *gradient;
    UIButton *backButton;
}
@end
@implementation CCNaviHeaderView

CCNaviHeaderView* mInstance;

-(CCNaviHeaderView*) newInstance:(NSString*)title
{
    mInstance =[[CCNaviHeaderView alloc] initWithFrame: CGRectMake(0, 0, SYSTEM_WIDTH, SYSTITLEHEIGHT) title:title];
    return mInstance;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int originy=(SYSTITLEHEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        UIColor *startColor =UIColorFromRGB(0x74C4DF);
        UIColor *endColor = [UIColor naviBarColor];
        gradient.colors = [NSArray arrayWithObjects:(id)[endColor CGColor],
                           (id)[endColor CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, originy, frame.size.width, LABELHEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=title;
        label.userInteractionEnabled=YES;
        [self addSubview:label];
        
    }
    return self;
}

-(CCNaviHeaderView*) newInstance:(NSString*)title andBackGruondColor:(UIColor *)backColor
{
    mInstance =[[CCNaviHeaderView alloc] initWithFrame: CGRectMake(0, 0, SYSTEM_WIDTH, SYSTITLEHEIGHT) title:title andBackGruondColor:backColor];
    return mInstance;
}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title andBackGruondColor:(UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int originy=(SYSTITLEHEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        gradient.colors = [NSArray arrayWithObjects:(id)[backColor CGColor],
                           (id)[backColor CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, originy, frame.size.width, LABELHEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=title;
        label.userInteractionEnabled=YES;
        [self addSubview:label];
        
    }
    return self;
}

- (void)addLeftButton:(UIButton *)leftButton
{
    CGRect rect = leftButton.frame;
    rect.origin.x = 0;
    rect.origin.y = (SYSTITLEHEIGHT-rect.size.height)/2+statusBarHeight()/2;
    leftButton.frame = rect;
    [self addSubview:leftButton];
}
- (void)addRightButton:(UIButton *)rightButton
{
    CGRect rect = rightButton.frame;
    rect.origin.x = self.frame.size.width - rect.size.width-14;
    rightButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:16];
    rect.origin.y = (SYSTITLEHEIGHT-rect.size.height)/2+statusBarHeight()/2;
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    rightButton.frame = rect;
    [self addSubview:rightButton];
}
- (void)resetTitle:(NSString*)title
{
    label.text=title;
}

- (void)addBackButtonWithTarget:(id)target action:(SEL)action{
    backButton = [CCButton backButtonWithtarget:target action:action];
    [self addSubview:backButton];
}

- (void)hiddenBackButton{
    backButton.hidden = YES;
}
- (void)setNewBackGrondColor:(UIColor *)newColor{
    gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[newColor CGColor],
                       (id)[newColor CGColor],nil];
    [self.layer insertSublayer:gradient atIndex:0];
}
@end
