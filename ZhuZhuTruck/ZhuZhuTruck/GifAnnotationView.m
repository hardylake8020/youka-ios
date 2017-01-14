//
//  GifAnnotationView.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/1/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "GifAnnotationView.h"
@implementation GifAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        [self setBackgroundColor:[UIColor clearColor]];
        self.annotationView = [[UIWebView alloc]initWithFrame:self.bounds];
        self.annotationView.scalesPageToFit = YES;
        self.annotationView.backgroundColor = [UIColor clearColor];
        self.annotationView.opaque = NO;
        [self addSubview:self.annotationView];
    }
    return self;
}

- (void)showGifWithFileName:(NSString *)gifName{
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    [self.annotationView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}

@end
