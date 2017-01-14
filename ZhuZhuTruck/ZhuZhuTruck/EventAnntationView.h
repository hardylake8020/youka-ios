//
//  EventAnntationView.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface EventAnntationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *annotationView;
- (void)setEventImage:(NSString*)imageName;
@end
