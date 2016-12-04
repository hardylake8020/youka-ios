//
//  CCAlert.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
void alert_showErrMsg(NSString* msg);
void alert_showInfoMsg(NSString* msg);
//void show_progress();
//void dismiss_progress();
BOOL isAlert_progress_show();
void toast_showInfoMsg(NSString* msg,CGFloat bottomOffset);

