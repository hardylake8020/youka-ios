//
//  EventAnntationView.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "EventAnntationView.h"

@implementation EventAnntationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        [self setBackgroundColor:[UIColor clearColor]];
        self.annotationView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.annotationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.annotationView];
    }
    return self;
}

- (void)setEventImage:(NSString*)imageName{
    self.annotationView.image = [UIImage imageNamed:imageName];
}

@end
