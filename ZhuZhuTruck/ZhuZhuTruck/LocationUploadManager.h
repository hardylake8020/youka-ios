//
//  LocationUploadManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/27.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationUploadManager : NSObject
+(id)sharedManager;
- (void)startUploadArray;
@end
