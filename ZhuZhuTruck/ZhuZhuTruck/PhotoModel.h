//
//  PhotoModel.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol PhotoModel <NSObject>
@end

@interface PhotoModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *url;
@end
