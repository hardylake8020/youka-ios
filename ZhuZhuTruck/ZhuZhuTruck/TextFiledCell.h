//
//  TextFiledCell.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFiledModel.h"
@interface TextFiledCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
- (void)showTextFileCellWithModel:(TextFiledModel*)model;
@end
