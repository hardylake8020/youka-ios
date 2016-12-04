//
//  NSDictionary+Tool.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tool)
-(NSString*) stringForKey:(NSString*)key;
-(int) intForKey:(NSString*)key;
-(double) doubleForKey:(NSString*)key;
-(BOOL) boolForKey:(NSString*)key;
-(NSString*) stringForUpKey:(NSString*)key;
-(BOOL)hasKey:(NSString*)key;
@end
