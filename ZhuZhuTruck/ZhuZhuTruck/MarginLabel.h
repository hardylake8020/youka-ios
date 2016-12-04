//
//  MarginLabel.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/19.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarginLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
