//
//  OilCardCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"
@interface OilCardCell : UITableViewCell
- (void)showCardCellWithModel:(CardModel *)model;
- (void)showSeletedCardCellWithModel:(CardModel *)model;
@end
