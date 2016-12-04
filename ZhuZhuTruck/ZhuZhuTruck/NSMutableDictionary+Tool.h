//
//  NSMutableDictionary+Tool.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Tool)
-(void) put:(NSObject*) object key:(NSString*)key;
-(void) putBool:(BOOL)value key:(NSString*)key;
-(void) putInt:(int)value key:(NSString*)key;
-(NSString*) stringForKey:(NSString*)key;
-(int) intForKey:(NSString*)key;
-(double) doubleForKey:(NSString*)key;
-(BOOL) boolForKey:(NSString*)key;
-(void) putKey:(NSObject*) object key:(NSString*)key;
-(NSString*) stringForUpKey:(NSString*)key;
-(BOOL)hasKey:(NSString*)key;
@end

