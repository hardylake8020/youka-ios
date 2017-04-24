//
//  TextFiledCell.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "TextFiledCell.h"
#import "UIColor+CustomColors.h"

@interface TextFiledCell ()<UITextFieldDelegate>
@property (nonatomic, strong) TextFiledModel *model;
@end

@implementation TextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textFiled.borderStyle = UITextBorderStyleNone;
    self.lineImageView.frame = CGRectMake(90, 0, 0.5, 50);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textFiled.delegate = self;
    self.textFiled.returnKeyType = UIReturnKeyDone;
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)showTextFileCellWithModel:(TextFiledModel*)model{
    self.model = model;
    self.titleLabel.text = model.title;
    self.textFiled.placeholder = model.placeHolder;
    self.textFiled.text = model.text;
    if (model.isChange) {
        self.textFiled.textColor = [UIColor customGreenColor];
    }else{
        self.textFiled.textColor = [UIColor blackColor];
    }
    if (model.isTitle) {
        self.textFiled.enabled = NO;
    }else{
        self.textFiled.enabled = YES;
    }
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (self.model.isTitle) {
//        return NO;
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textFiled resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.model.text = textField.text;
    self.model.isChange = YES;
    self.textFiled.textColor = [UIColor customGreenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
