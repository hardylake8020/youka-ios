//
//  ErrorMaskView.m
//  ZhengChe
//
//  Created by CongCong on 16/9/25.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ErrorMaskView.h"
#import "Constants.h"
#import <UIView+SDAutoLayout.h>
@implementation ErrorMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emptylist"]];
//    [self addSubview:self.imageView ];
    self.messageLabel = [[UILabel alloc]init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.text = @"暂无";
    _messageLabel.textColor = UIColorFromRGB(0x999999);
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    
//    self.imageView .sd_layout
//    .centerXEqualToView(self)
//    .centerYIs(self.height/2-40)
//    .widthIs(self.imageView .width)
//    .heightIs(self.imageView .height);
//    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    _messageLabel.sd_layout
    .widthIs(300)
    .heightIs(45)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
}

@end
