//
//  NSDictionary+Tool.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "NSDictionary+Tool.h"

@implementation NSDictionary (Tool)
-(id)objectForLowKey:(NSString*)key
{
    return [self objectForKey:[key lowercaseString]];
}

-(NSString*) stringForKey:(NSString*)key
{
    NSString* value=[self objectForLowKey:key];
    if(!value||[value isKindOfClass:[NSNull class]])
        return @"";
    return value;
}

-(int) intForKey:(NSString*)key
{
    NSNumber* value=[self objectForLowKey:key];
    return value==nil?0:[value intValue];
}

-(double) doubleForKey:(NSString*)key
{
    NSString* value=[self stringForKey:key];
    return value==nil?0:[value doubleValue];
}

-(BOOL) boolForKey:(NSString*)key
{
    NSNumber* value=[self objectForLowKey:key];
    return value==nil?NO:[value boolValue];
}

-(NSString*) stringForUpKey:(NSString*)key
{
    NSString* value=[self objectForKey:key];
    return value==nil?@"":value;
}

-(BOOL)hasKey:(NSString*)key
{
    if([[self allKeys] containsObject:key])
        return YES;
    return NO;
}
@end
