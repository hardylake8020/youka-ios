//
//  DiverHttpRequstManager.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/21.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DiverHttpRequstManager.h"
#import <AFNetworking.h>
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>
#import "NSDictionary+Tool.h"
#import "CCTool.h"
#import "Constants.h"
#import "CCUserData.h"

@implementation DiverHttpRequstManager
+(instancetype)requestManager
{
    static id requestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[self alloc] init];
        
    });
    return requestManager;
}

- (void)getWithRequestBodyString:(NSString *)header
                      parameters:(id)parameters
                     resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock
{
    if (!isConnecting()) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法连接到网络"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [[NSError alloc]initWithDomain:CustomErrorDomain code:-404 userInfo:userInfo];
        if (resultBlock) {
            return resultBlock(nil,customError);
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    
    NSString *URL = [self requestUrl:header];
    
    CCLog(@"GET--URL:%@   \n paraters:%@",URL,parameters);
    
    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"GET --> %@, \n Callback Thread%@", URL, [NSThread currentThread]); //自动返回主线程
        if (resultBlock) {
            NSDictionary *result = (NSDictionary*)responseObject;
            NSError *error;
            if ([result hasKey:@"err"]) {
                NSDictionary *errDict = [result objectForKey:@"err"];
                NSString *errType = [errDict stringForKey:@"type"];
                NSLog(@"errtype:----->%@",errType);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errType                                                                     forKey:NSLocalizedDescriptionKey];
                error = [[NSError alloc]initWithDomain:errType code:-200 userInfo:userInfo];
                
                if ([error.localizedDescription isEqualToString:@"driver_token_invalid"]||[error.localizedDescription isEqualToString:@"undefined_access_token"]||[error.localizedDescription isEqualToString:@"driver_not_exist"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_TOKEN_INVILID_NOTI object:nil];
                }
            }
            resultBlock(result,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法连接到网络"                                                                      forKey:NSLocalizedDescriptionKey];
            error = [[NSError alloc]initWithDomain:error.localizedDescription code:-404 userInfo:userInfo];
        }
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}

- (void)postWithRequestBodyString:(NSString *)header
                       parameters:(id)parameters
                      resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock
{
    if (!isConnecting()) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法连接到网络"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [[NSError alloc]initWithDomain:CustomErrorDomain code:-404 userInfo:userInfo];
        if (resultBlock) {
            return resultBlock(nil,customError);
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    
    NSString *URL = [self requestUrl:header];
    CCLog(@"POST--URL:%@\n paraters:%@",URL,parameters);
    
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST --> %@, \n Callback Thread%@", URL, [NSThread currentThread]); //自动返回主线
        if (resultBlock) {
            NSDictionary *result = (NSDictionary*)responseObject;
            NSError *error;
            if ([result hasKey:@"err"]) {
                NSDictionary *errDict = [result objectForKey:@"err"];
                NSString *errType = [errDict stringForKey:@"type"];
                NSLog(@"errtype:----->%@",errType);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errType                                                                     forKey:NSLocalizedDescriptionKey];
                error = [[NSError alloc]initWithDomain:errType code:-200 userInfo:userInfo];
                if ([error.localizedDescription isEqualToString:@"driver_token_invalid"]||[error.localizedDescription isEqualToString:@"undefined_access_token"]||[error.localizedDescription isEqualToString:@"driver_not_exist"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_TOKEN_INVILID_NOTI object:nil];
                }
            }
            resultBlock(result,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法连接到网络"                                                                      forKey:NSLocalizedDescriptionKey];
            error = [[NSError alloc]initWithDomain:error.localizedDescription code:-404 userInfo:userInfo];
        }
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}


- (NSString *)requestUrl:(NSString *)bodyString
{
    return [NSString stringWithFormat:@"%@%@",DRIVER_BASE_URL,bodyString];
}

@end
