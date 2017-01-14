//
//  GifAnnotationView.h
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface GifAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIWebView *annotationView;
- (void)showGifWithFileName:(NSString *)gifName;
@end
