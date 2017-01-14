//
//  RouteAnnotation.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//
#import <BaiduMapAPI_Map/BMKMapComponent.h>

typedef enum : NSUInteger {
    RutoPickUp,
    RutoDelivery,
    RutoHalfWay,
    RutoPickupSign,
    RutoDeliverySign,
    RutoPassPoint,
} RutoAnnotationType;

@interface RouteAnnotation : BMKPointAnnotation
@property (nonatomic) RutoAnnotationType type;
@property (nonatomic) NSInteger degree;
//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;
@end
