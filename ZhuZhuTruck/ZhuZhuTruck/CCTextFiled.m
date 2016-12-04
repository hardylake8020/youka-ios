//
//  CCTextFiled.m
//  ZhengChe
//
//  Created by CongCong on 16/9/12.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCTextFiled.h"
#import "CCTool.h"
#import "UIColor+CustomColors.h"
@implementation CCTextFiled

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self setBorderStyle:UITextBorderStyleNone];
        [self setFont:fontBysize(16)];
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 10, frame.size.height)];//左端缩进15像素
        self.leftView = view;
        self.leftViewMode =UITextFieldViewModeAlways;
        [self setTextColor:[UIColor textDarkColor]];
        [self setReturnKeyType:UIReturnKeyDone];//改变按钮
        [self setMinimumFontSize:8];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];//内容居中
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setKeyboardAppearance:UIKeyboardAppearanceDefault];//键盘外观
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged ];
        self.layer.cornerRadius=6;
//        [self addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self setAdjustsFontSizeToFitWidth:YES];
        UIColor* color=ColorFromRGB(0xbdbdbd);
        self.layer.borderColor=color.CGColor;
        self.layer.borderWidth=0.5;
    }
    return self;
}
-(void) setLeftImg:(UIImageView*)imgView{
    if(imgView){
        self.leftView = imgView;
        self.leftViewMode =UITextFieldViewModeAlways;
    }
}


@end
