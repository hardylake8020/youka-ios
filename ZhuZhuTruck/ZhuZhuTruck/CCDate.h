//
//  CCDate.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* today();
NSString* now();
NSString* nowToWeb();
NSDate* string2Date(NSString* date);
NSString* thisMohth();
NSMutableArray* weekBeginAndEnd(NSString* date);
NSString* lastAndnextWeek(NSString* date,int type);
NSString* diffDate(NSString* date,int dateDiff);
NSDate* string2Time(NSString* date);
NSDate* string2DateTime(NSString* date);
NSString *dateStringWithDateAndFormart(NSString *dateString,NSString *format);
