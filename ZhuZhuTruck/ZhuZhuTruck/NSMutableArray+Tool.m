//
//  NSMutableArray+Tool.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "NSMutableArray+Tool.h"

@implementation NSMutableArray (Tool)
-(BOOL)isEmpty
{
    if(!self||[self isKindOfClass:[NSNull class]])
        return YES;
    return NO;
}
-(void) addDict:(NSMutableDictionary*) dict
{
    [self addObject:dict];
}
@end
