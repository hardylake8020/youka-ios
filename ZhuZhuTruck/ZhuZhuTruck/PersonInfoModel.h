//
//  PersonInfoModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, assign) BOOL isText;



- (instancetype)initWithTitle:(NSString*)title photoName:(NSString *)photoName andKey:(NSString *)key;

@end
