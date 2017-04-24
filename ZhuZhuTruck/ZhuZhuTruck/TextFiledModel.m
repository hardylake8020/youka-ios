//
//  TextFiledModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/28.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "TextFiledModel.h"

@implementation TextFiledModel
- (instancetype)initWithTitle:(NSString*)title text:(NSString *)text andKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _title = title;
        _text = text;
        _key = key;
    }
    return self;
}
- (NSString*)text{
    return _text?_text:@"";
}
@end
