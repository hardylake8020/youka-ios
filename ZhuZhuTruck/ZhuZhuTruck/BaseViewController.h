//
//  BaseViewController.h
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//
#import "CCTool.h"
#import "CCFile.h"
#import "CCDate.h"
#import "CCColor.h"
#import "CCAlert.h"
#import "QRCodeVC.h"
#import "CCButton.h"
#import "Constants.h"
#import "DBManager.h"
#import "CCUserData.h"
#import "TenderCell.h"
#import "PhotosCell.h"
#import "OilCardCell.h"
#import "ETCCardCell.h"
#import "WaybillCell.h"
#import "CCTextFiled.h"
#import "AppDelegate.h"
#import "MarginLabel.h"
#import <UIKit/UIKit.h>
#import "DrvierCarCell.h"
#import "ACActionSheet.h"
#import <SVProgressHUD.h>
#import "NSString+Tool.h"
#import "ErrorMaskView.h"
#import "AddressManager.h"
#import "OperationButton.h"
#import "LocationTracker.h"
#import "SeverTimeManager.h"
#import "CCNaviHeaderView.h"
#import "TenderProcessCell.h"
#import "TenderSucceedCell.h"
#import "HttpRequstManager.h"
#import "NSDictionary+Tool.h"
#import "UIAlertView+Blocks.h"
#import <MJRefresh/MJRefresh.h>
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import "LocationUploadManager.h"
#import "NSMutableDictionary+Tool.h"
#import <JSONKit-NoWarning/JSONKit.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong)CCNaviHeaderView *naviHeaderView;
- (void)addNaviHeaderViewWithTitle:(NSString *)title;
@end
