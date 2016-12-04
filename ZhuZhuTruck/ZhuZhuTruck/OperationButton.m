//
//  OperationButton.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "OperationButton.h"
#import "NSString+FontAwesome.h"
#import "CCColor.h"
#import "Constants.h"
@interface OperationButton (){
    OperationButtonType _type;
    NSString *_text;
    BOOL _seleted;
    UILabel *_textLabel;
    UILabel *_iconLabel;
    UIImageView *_seletedImage;
}

@end

@implementation OperationButton
- (id)initWithFrame:(CGRect)frame buttonType:(OperationButtonType)type buttonText:(NSString *)text isSeleted:(BOOL)isSeleted{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _text = text;
        _seleted = isSeleted;
        [self initContent];
    }
    return self;
}

- (void)initContent{
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateHighlighted];
    _iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.1, self.frame.size.width, self.frame.size.height*0.6)];
    [_iconLabel setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
    _iconLabel.textAlignment = NSTextAlignmentCenter;
    _iconLabel.textColor  = [UIColor colorWithWhite:0.2 alpha:1];
    switch (_type) {
        case ZHONGTUBUTTON:
        {
            _iconLabel.text = [NSString fontAwesomeIconStringForEnum:FAExclamationTriangle];
        }
            break;
        case JINCHANGBUTTON:
        {
            _iconLabel.text = [NSString fontAwesomeIconStringForEnum:FASignIn];
        }
            break;
        case SAOYISAOBUTTON:
        {
            _iconLabel.text = [NSString fontAwesomeIconStringForEnum:FAQrcode];
        }
            break;
        case PAIZHAOBUTTON:
        {
            _iconLabel.text = [NSString fontAwesomeIconStringForEnum:FACamera];
        }
            break;
        default:
            break;
    }
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.3)];
    NSLog(@"%@",_text);
    _textLabel.text = _text;
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor blackColor];
    [self addSubview:_iconLabel];
    [self addSubview:_textLabel];
    _seletedImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-30, 0, 30, 30)];
    _seletedImage.image = [UIImage imageNamed:@"check"];
    _seletedImage.hidden = YES;
    [self addSubview:_seletedImage];
    if (_seleted) {
        _seletedImage.hidden = NO;
    }
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    horizontalLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
    verticalLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self addSubview:verticalLine];
    
}
- (void)setSelectedTitle:(NSString *)Title{
    _textLabel.text = Title;
    //iconLabel.textColor = UIColorFromRGB(0x3ebf43);
    _seletedImage.hidden = NO;
}
- (void)setUnSeletedTitle:(NSString *)title{
    _textLabel.text = title;
    //iconLabel.textColor = [UIColor blackColor];
    _seletedImage.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
