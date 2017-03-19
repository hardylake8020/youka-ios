//
//  WinnerModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/2/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  WinnerModel <NSObject>
@end

@interface WinnerModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *_id;
@property (nonatomic, copy) NSString<Optional> *username;
@end
