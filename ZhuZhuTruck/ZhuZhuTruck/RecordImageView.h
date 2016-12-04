//
//  RecordImageView.h
//  ZhengChe
//
//  Created by CongCong on 16/9/20.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordImageView : UIView
- (void)showVoiceImageWith:(int)lowPassResults;
- (void)setStatus:(NSString *)status;
- (void)stopRecord;
- (void)show;
@end
