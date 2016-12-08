//
//  CCDate.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCDate.h"
#import "NSString+Tool.h"
#import "NSMutableDictionary+Tool.h"
#import "NSMutableArray+Tool.h"
NSString* dateTime(NSString* format)
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    return today;
}

NSString* today()
{
    return dateTime(@"yyyy-MM-dd");
}

NSString* now()
{
    return dateTime(@"yyyy-MM-dd HH:mm:ss");
}

NSString* nowTime()
{
    return dateTime(@"HH:mm:ss");
}

NSString* nowToWeb()
{
    return [NSString stringWithFormat:@"%@T%@",today(),nowTime()];
}

NSDate* string2Date(NSString* date)
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:(@"yyyy-MM-dd")];
    NSDate *willdate = [formate dateFromString:date];
    return willdate;
}

NSDate* string2Time(NSString* date)
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:(@"HH:mm")];
    NSDate *willdate = [formate dateFromString:date];
    return willdate;
}

NSDate* string2DateTime(NSString* date)
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:(@"yyyy-MM-dd HH:mm")];
    NSDate *willdate = [formate dateFromString:date];
    return willdate;
}

NSString* thisMohth()
{
    return dateTime(@"yyyy-MM");
}

NSMutableArray* weekBeginAndEnd(NSString* date)
{
    NSMutableArray* dateList=[[NSMutableArray alloc] init];
    
    NSMutableDictionary* dateDic;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    
    
    //获取当前周的开始和结束日期
    int currentWeek = 0;
    //    NSDate * newDate = [NSDate date];
    NSDate *newDate = [formatter dateFromString:date];
    NSTimeInterval secondsPerDay1 = 24 * 60 * 60 * (abs(currentWeek)*7);
    if (currentWeek > 0)
    {
        newDate = [newDate dateByAddingTimeInterval:+secondsPerDay1];//目标时间
    }else{
        newDate = [newDate dateByAddingTimeInterval:-secondsPerDay1];//目标时间
    }
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSDateFormatter *myformatter = [[NSDateFormatter alloc] init];
    
    [myformatter setTimeZone:timeZone];
    [myformatter setDateFormat:@"dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    if (ok) {
        for (int i=0;i<7;i++) {
            endDate = [beginDate dateByAddingTimeInterval:i * 24 * 60 * 60];
            dateDic=[NSMutableDictionary dictionary];
            [dateDic put:[myformatter stringFromDate:endDate] key:@"date"];
            [dateDic put:[formatter stringFromDate:endDate] key:@"wholedate"];
            NSLog(@"日期:%@",[formatter stringFromDate:endDate]);
            //            NSString *ss=[date substringFromIndex:date.length-2];
            //            NSLog(@"1111日期:%@",ss);
            if([[formatter stringFromDate:endDate] isEqualToString:date])
                [dateDic putBool:YES key:@"selected"];
            else
                [dateDic putBool:NO key:@"selected"];
            [dateList addDict:dateDic];
        }
        return dateList;
    }else {
        return nil;
    }
    return nil;
}

NSString* lastAndnextWeek(NSString* date,int type)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    
    //获取当前周的开始和结束日期
    //    int currentWeek = 0;
    //    NSDate * newDate = [NSDate date];
    NSDate *newDate = [formatter dateFromString:date];
    NSTimeInterval secondsPerDay1 = 24 * 60 * 60 * 7;
    if (type > 0)
    {
        newDate = [newDate dateByAddingTimeInterval:+secondsPerDay1];//目标时间
    }else{
        newDate = [newDate dateByAddingTimeInterval:-secondsPerDay1];//目标时间
    }
    NSLog(@"12日期:%@",[formatter stringFromDate:newDate]);
    return [formatter stringFromDate:newDate];
}

NSString* diffDate(NSString* date,int dateDiff)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    
    //获取当前周的开始和结束日期
    //    int currentWeek = 0;
    //    NSDate * newDate = [NSDate date];
    NSDate *newDate = [formatter dateFromString:date];
    NSTimeInterval secondsPerDay1 = 24 * 60 * 60 * dateDiff;
    
    newDate = [newDate dateByAddingTimeInterval:+secondsPerDay1];//目标时间
    
    NSLog(@"12日期:%@",[formatter stringFromDate:newDate]);
    return [formatter stringFromDate:newDate];
}


NSString *dateStringWithDateAndFormart(NSString *dateString,NSString *format){
    NSDate *date = [dateString dateFromString];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    NSString *timeSting = [formatter stringFromDate:date];
    return timeSting;
}








