//
//  TextFiledModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextFiledModel : NSObject
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, copy  ) NSString *key;
@property (nonatomic, copy  ) NSString *placeHolder;
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, assign) BOOL isTitle;
- (instancetype)initWithTitle:(NSString*)title text:(NSString *)text andKey:(NSString *)key;
@end
