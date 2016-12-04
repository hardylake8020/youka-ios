//
//  NSMutableDictionary+Tool.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "NSMutableDictionary+Tool.h"

@implementation NSMutableDictionary (Tool)
-(void) put:(NSObject*) object key:(NSString*)key
{
    if (object==nil) {
        return;
    }
    [self setObject:object forKey:[key lowercaseString]];
}

-(void) putBool:(BOOL)value key:(NSString*)key
{
    [self put:[NSNumber numberWithBool:value] key:key];
}

-(void) putInt:(int)value key:(NSString*)key
{
    [self put:[NSNumber numberWithInt:value] key:key];
}

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

-(void) putKey:(NSObject*) object key:(NSString*)key
{
    [self setObject:object forKey:key];
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
