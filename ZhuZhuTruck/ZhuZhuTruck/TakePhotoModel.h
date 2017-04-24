//
//  TakePhotoModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePhotoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isChange;
- (instancetype)initWithTitle:(NSString*)title photoName:(NSString *)photoName andKey:(NSString *)key;
@end
