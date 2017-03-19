//
//  TenderModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/13.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderModel.h"
#import "CCUserData.h"
@implementation TenderModel
- (NSInteger)getBindderPrice{
    for (TenderRecordModel*model in self.tender_records) {
        if ([model.driver isEqualToString:user_id()]) {
            return model.price.integerValue;
        }
    }
    return 0;
}
- (BOOL)isAlreadyBind{
    for (TenderRecordModel*model in self.tender_records) {
        if ([model.driver isEqualToString:user_id()]) {
            return YES;
        }
    }
    return NO;
}
@end
