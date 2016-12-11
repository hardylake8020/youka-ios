//
//  TimeLineCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"
@interface TimeLineCell : UITableViewCell
- (void)showEventWithModel:(EventModel *)eventModel;
@end
