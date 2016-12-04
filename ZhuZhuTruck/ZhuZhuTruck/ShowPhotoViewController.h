//
//  ShowPhotoViewController.h
//  ZhengChe
//
//  Created by CongCong on 16/9/18.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DeletedFileCallBack)(NSString *fileName);
@interface ShowPhotoViewController : BaseViewController
- (instancetype)initWithFileName:(NSString *)fileName;
- (instancetype)initWithEditFileName:(NSString *)fileName editCallBack:(DeletedFileCallBack)callBack;
@end
