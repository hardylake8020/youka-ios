//
//  QnUploadManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QnUploadManager : NSObject
+(id)sharedManager;
- (void)getToken;
@end
