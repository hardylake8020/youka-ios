//
//  DBManager.h
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "OrderModel.h"
@interface DBManager : NSObject
+ (DBManager *)sharedManager;
- (BOOL)inserPhotoWithPhotoName:(NSString *)photoName orderId:(NSString *)_id andStatus:(DriverOperationType)status;
- (void)insertPhotosWithPhotoArray:(NSArray *)photoArray orderId:(NSString *)_id andStatus:(DriverOperationType)status;
- (NSArray*)readAllUnUploadPhotos;
- (NSArray*)readAllPhotosWithId:(NSString *)_id andStatus:(DriverOperationType)status;
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

- (void)insertOrderWithOrderModel:(OrderModel *)orderModel;
- (void)orderConfirmSucceedWithOrder:(OrderModel *)orderModel;
- (void)orderPickupSignSucceedWithOrder:(OrderModel *)orderModel;
- (void)orderPickupSucceedWithOrder:(OrderModel *)orderModel;
- (void)orderDeliverySignSucceedWithOrder:(OrderModel *)orderModel;
- (void)orderDeliverySucceedWithOrder:(OrderModel *)orderModel;
- (void)updateOrderWithOrderModel:(OrderModel *)orderModel;
- (BOOL)deletAllOrdersWithStatus:(NSNumber *)status;
- (void)inserOrdersWithOrders:(NSArray *)orders;
- (BOOL)deleteOrderWithOrderId:(NSString *)orderId;

- (NSArray *)readAllUnpickupOrders;
- (NSArray *)readAllUnDeliveryOrders;
- (NSArray *)readAllCompletedOrders;
@end
