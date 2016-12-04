//
//  CCNaviHeaderView.h
//  ZhengChe
//
//  Created by CongCong on 16/9/10.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCNaviHeaderView : UIView
- (CCNaviHeaderView*)newInstance:(NSString*)title;
- (void)addLeftButton:(UIButton *)leftButton;
- (void)addRightButton:(UIButton *)rightButton;
- (void)resetTitle:(NSString*)title;
- (void)addBackButtonWithTarget:(id)target action:(SEL)action;
- (void)hiddenBackButton;
@end
