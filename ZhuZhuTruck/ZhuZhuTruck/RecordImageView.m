//
//  RecordImageView.m
//  ZhengChe
//
//  Created by CongCong on 16/9/20.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "RecordImageView.h"


@interface RecordImageView (){
    UIImageView *_voiceImageView;
    UILabel *_statusLabel;
    NSString *_statusString;
    NSMutableArray *volumImages;
}

@end

@implementation RecordImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10;
    self.alpha = 0.8;
    self.backgroundColor = [UIColor grayColor];
    UIImageView *deviceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RecordingBkg"]];
    deviceImageView.frame = CGRectMake(30 ,10,40,110);
    [self addSubview:deviceImageView];
    _voiceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90,10,30,100)];
    [self addSubview:_voiceImageView];
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 120, 20)];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.font = [UIFont boldSystemFontOfSize:14];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];
    //音量图片数组
    volumImages = [[NSMutableArray alloc]initWithObjects:@"RecordingSignal001",@"RecordingSignal002",@"RecordingSignal003",
                   @"RecordingSignal004", @"RecordingSignal005",@"RecordingSignal006",
                   @"RecordingSignal007",@"RecordingSignal008",   nil];
}
- (void)setStatus:(NSString *)status{
    _statusString = status;
}
- (void)showVoiceImageWith:(int)lowPassResults{
    if (lowPassResults>=8) {
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:7]];
    }else if(lowPassResults>=7){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:6]];
    }else if(lowPassResults>=6){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:5]];
    }else if(lowPassResults>=5){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:4]];
    }else if(lowPassResults>=4){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:3]];
    }else if(lowPassResults>=3){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:2]];
    }else if(lowPassResults>=2){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:1]];
    }else if(lowPassResults>=1){
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
    }else{
        _voiceImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
    }
    _statusLabel.text = _statusString;
}
- (void)show{
    self.hidden = NO;
}
- (void)stopRecord{
    self.hidden = YES;
}
@end
