//
//  TruckDetailCellModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/24.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TruckDetailCellModel.h"

@implementation TruckDetailCellModel
- (void)setSubTitle:(NSString *)subTitle{
    if (subTitle) {
        _subTitle = subTitle;
    }else{
        _subTitle = @"";
    }
}

@end
