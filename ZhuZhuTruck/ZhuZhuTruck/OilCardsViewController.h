//
//  OilCardsViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

@interface OilCardsViewController : BaseViewController
@property (nonatomic, assign) BOOL isSeletedMode;
- (instancetype)initWithTenderModel:(TenderModel *)tenderModel andTruckModel:(TruckModel *)truckModel;
@end
