//
//  TenderDetailCellModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TenderDetailCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL    isLight;
@property (nonatomic, assign) float   cellHight;
@property (nonatomic, assign) BOOL    isPhone;
@property (nonatomic, assign) BOOL    noBottomLine;
@property (nonatomic, assign) NSInteger    upDown;//0 不动 1向下 2向上 11 向下++ 22 向上++
@end
