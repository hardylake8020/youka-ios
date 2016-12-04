//
//  AppDelegate.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/11/29.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "AppDelegate.h"
#import <JPUSHService.h>
#import "LaunchViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface AppDelegate ()

@end

@implementation AppDelegate
+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    //appKey
    [JPUSHService setupWithOption:launchOptions appKey:@"94839ab20286805683e7080e" channel:@"Publish channel" apsForProduction:YES];
    
    
    
    BMKMapManager* mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:@"8fbe899ac1f8c2f54f09517c" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    LaunchViewController *lauchPage = [[LaunchViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lauchPage];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"registrationID====>%@",[JPUSHService registrationID]);
//    [[NSNotificationCenter defaultCenter] postNotificationName:GET_JPUSH_REGISEDID_NOTI object:nil];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
//    NSLog(@"didRecivePush -------> %@",[userInfo stringForKey:@"push_type"]);
//    
//    if ([[userInfo stringForKey:@"push_type"] isEqualToString:@"un_start_order"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:REFESH_UN_START_ORDERS object:nil];
//    }
//    else if ([[userInfo stringForKey:@"push_type"] isEqualToString:@"on_way_order"]) {
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:REFESH_ON_WAY_ORDERS object:nil];
//    }
//    else if ([[userInfo stringForKey:@"push_type"] isEqualToString:@"transfer_completed"]) {
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:REFESH_UN_START_ORDERS object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:REFESH_ON_WAY_ORDERS object:nil];
//    }
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState==UIApplicationStateActive) {
        [self vibrate];
    }
}

- (void)vibrate   {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1009);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
