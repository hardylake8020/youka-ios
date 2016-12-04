//
//  QRCodeVC.h
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRCodeCallBackBlock)(NSString *codeString);


@interface QRCodeVC : UIViewController

- (instancetype)initWithCallBackHandler:(QRCodeCallBackBlock)callBackHandler;

@end
