//
//  RouteAnnotation.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"
#import "EventAnntationView.h"

@implementation RouteAnnotation
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview
{
    BMKAnnotationView* view = nil;
    switch (_type) {
        case RutoPickUp:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"pickup_node"];
            if (view == nil) {
                view = [[EventAnntationView alloc] initWithAnnotation:self reuseIdentifier:@"pickup_node"];
                [(EventAnntationView*)view setEventImage:@"map_pickup.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case RutoDelivery:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"delivery_node"];
            if (view == nil) {
                view = [[EventAnntationView alloc]initWithAnnotation:self reuseIdentifier:@"delivery_node"];
                [(EventAnntationView*)view setEventImage:@"map_delivery.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case RutoHalfWay:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"halfway_node"];
            if (view == nil) {
                view = [[EventAnntationView alloc]initWithAnnotation:self reuseIdentifier:@"halfway_node"];
                [(EventAnntationView*)view setEventImage:@"map_delivery.png"];
            }
        }
            break;
        case RutoPickupSign:
        case RutoDeliverySign:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"sign_node"];
            if (view == nil) {
                view = [[EventAnntationView alloc]initWithAnnotation:self reuseIdentifier:@"sign_node"];
                [(EventAnntationView*)view setEventImage:@"map_sign.png"];
            }
        }
            break;
        case RutoPassPoint:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"route_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"icon_direction.png"];
            view.image = [image imageRotatedByDegrees:_degree];
        }
            break;
        default:
            break;
    }
    if (view) {
        view.annotation = self;
        view.canShowCallout = YES;
    }
    return view;
}

@end
