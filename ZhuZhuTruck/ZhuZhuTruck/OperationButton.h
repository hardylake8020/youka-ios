//
//  OperationButton.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/3.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZHONGTUBUTTON,
    JINCHANGBUTTON,
    SAOYISAOBUTTON,
    PAIZHAOBUTTON,
} OperationButtonType;

@interface OperationButton : UIButton
-(id) initWithFrame:(CGRect)frame buttonType:(OperationButtonType)type buttonText:(NSString *)text isSeleted:(BOOL)isSeleted;
- (void)setSelectedTitle:(NSString *)Title;
- (void)setUnSeletedTitle:(NSString *)title;
@end
