//
//  TenderDetailCellModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailCellModel.h"
#import "Constants.h"
#import "NSString+Tool.h"
@implementation TenderDetailCellModel
- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    if (_isLight) {
        _cellHight = [subTitle sizeH:18 withLabelWidth:SYSTEM_WIDTH-120]+21;
    }else{
        _cellHight = [subTitle sizeH:16 withLabelWidth:SYSTEM_WIDTH-120]+21;
    }
}
@end
