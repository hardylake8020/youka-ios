//
//  PersonInfoCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/16.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoModel.h"
@interface PersonInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
- (void)showCellWithPhotoDict:(NSDictionary *)photoDict;
- (void)showCellWithPerInfoModel:(PersonInfoModel *)model;
@end
