//
//  MyDriversViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

@interface MyDriversViewController : BaseViewController
@property (nonatomic, assign) BOOL isSeletedMode;
@property (nonatomic, assign) BOOL isFormDetail;
- (id)initWithAssaginTenderModel:(TenderModel*)tenderModel;
@end
