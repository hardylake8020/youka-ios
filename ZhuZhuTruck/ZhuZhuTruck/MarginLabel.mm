//
//  MarginLabel.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/19.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "MarginLabel.h"

@implementation MarginLabel

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
