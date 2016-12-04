//
//  SeverTimeManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/23.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SeverTimeManager : NSObject
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) NSTimeInterval currentTimeIntervarl;
+(id)defaultManager;
- (void)getServerTime;
@end
