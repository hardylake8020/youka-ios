//
//  WaybillDetailCellModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "WaybillDetailCellModel.h"
#import "Constants.h"
#import "NSString+Tool.h"
@implementation WaybillDetailCellModel
- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    _cellHight = [subTitle sizeH:16 withLabelWidth:SYSTEM_WIDTH-120]+21;
}
@end
