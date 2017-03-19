//
//  AddPhotoViewController.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/16.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddPhotoCallBack)(NSString *photoName);

@interface AddPhotoViewController : BaseViewController
- (instancetype)initWithPhotoDict:(NSMutableDictionary *)dict andAddCallBack:(AddPhotoCallBack)callBack;
- (instancetype)initWithPersonInfoModel:(PersonInfoModel *)model andAddCallBack:(AddPhotoCallBack)callBack;
@end
