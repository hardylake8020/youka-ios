//
//  DBManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
+ (DBManager *)sharedManager;
- (BOOL)inserPhotoWithPhotoName:(NSString *)photoName;
- (void)insertPhotosWithPhotoArray:(NSArray *)photoArray;
- (NSArray*)readAllUnUploadPhotos;
- (BOOL)photoUploadSucceedWithPhotoName:(NSString *)photoName;
- (BOOL)photoDeletedWithPhotoName:(NSString *)photoName;
- (BOOL)inserVoiceWithVoiceName:(NSString *)voiceName;
- (NSArray*)readAllUnUploadVoices;
- (BOOL)voiceUploadSucceedWithVoiceName:(NSString *)voiceName;
- (BOOL)voiceDeleteWithVoiceName:(NSString *)voiceName;
- (BOOL)inserLocationWithLocationInfo:(NSString *)locationInfo;
- (NSArray*)readAllLocations;
- (BOOL)deleteLocationWithInfo:(NSString *)locationInfo;
- (BOOL)deletedAllLocations;
- (void)deleteLocationsWithLoctions:(NSArray *)locations;
@end
