//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#define LATITUDE  @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY  @"theAccuracy"
#import "Constants.h"
#import "CCAlert.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "LocationTracker.h"
#import "DBManager.h"
#import "CCTool.h"
#import "CCDate.h"
#import "NSMutableDictionary+Tool.h"
#import <JSONKit.h>
#import "SeverTimeManager.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface LocationTracker ()<BMKLocationServiceDelegate>
@property (nonatomic, strong) NSTimer *uploadSeverTimer;
@end

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                _locationManager.allowsBackgroundLocationUpdates = YES;
            }
			_locationManager.pausesLocationUpdatesAutomatically = NO;
		}
	}
	return _locationManager;
}

+ (BMKLocationService *)sharedBMKLocationService{
    static BMKLocationService *_locService;
    
    @synchronized(self) {
        if (_locService == nil) {
            _locService = [[BMKLocationService alloc] init];
            [_locService setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
            _locService.allowsBackgroundLocationUpdates = YES;
        }
    }
    return _locService;
}


+ (id)defaultLoactionTarker{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
	if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.stopLoction = YES;
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    
    BMKLocationService *bmkLoactionManager = [LocationTracker sharedBMKLocationService];
    bmkLoactionManager.delegate = self;
    [bmkLoactionManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [bmkLoactionManager startUserLocationService];
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
//    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    BMKLocationService *bmkLoactionManager = [LocationTracker sharedBMKLocationService];
    bmkLoactionManager.delegate = self;
    [bmkLoactionManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [bmkLoactionManager startUserLocationService];
}


- (void)startLocationTracking {
    NSLog(@"startLocationTracking");
    if (!self.stopLoction) {
        return;
    }
	if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
            
            RIButtonItem *deleteItem = [RIButtonItem itemWithLabel:@"去开启" action:^{
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告！定位服务未启用"
                                                                message:@"请到隐私->定位服务->开启长安民生整车的定位权限"
                                                       cancelButtonItem:nil
                                                       otherButtonItems:deleteItem, nil];
            [alertView show];

        }
        
        self.stopLoction = NO;
        NSTimeInterval time = 20.0;
        //开启计时器
        self.uploadSeverTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                 target:self
                                                               selector:@selector(updateLocationToServer)
                                                               userInfo:nil
                                                                repeats:YES];
        
        NSLog(@"authorizationStatus authorized");
        BMKLocationService *bmkLoactionManager = [LocationTracker sharedBMKLocationService];
        bmkLoactionManager.delegate = self;
        [bmkLoactionManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [bmkLoactionManager startUserLocationService];
	}
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    self.stopLoction = YES;
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    [self.uploadSeverTimer invalidate];
    BMKLocationService *bmkLoactionManager = [LocationTracker sharedBMKLocationService];
    [bmkLoactionManager stopUserLocationService];
}

#pragma mark - 百度地图Delegate Methods

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (self.stopLoction) {
        return;
    }
//    NSLog(@"locationManager didUpdateLocations");
    CLLocation * newLocation = userLocation.location;
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
    NSLog(@"TheNewLoaction --->%f ----> %f ---->%f",theLocation.latitude,theLocation.longitude,newLocation.horizontalAccuracy);
    //Select only valid location and also location with good accuracy
    if(newLocation!=nil&&theAccuracy>0
       &&theAccuracy<3000
       &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
        
        self.myLastLocation = theLocation;
        self.myLastLocationAccuracy= theAccuracy;
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
        [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
        [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
        
        //Add the vallid location with good accuracy into an array
        //Every 1 minute, I will select the best location based on accuracy and send to server
        [self.shareModel.myLocationArray addObject:dict];
    }
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:2 target:self
                                                    selector:@selector(stopLocationDelayBy2Seconds)
                                                    userInfo:nil
                                                     repeats:NO];
}


//Stop the locationManager
-(void)stopLocationDelayBy2Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
//    NSLog(@"locationManager stop Updating after 2 seconds");
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
   // NSLog(@"locationManager error:%@",error);
    if (self.stopLoction) {
        return;
    }
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            alert_showErrMsg(@"网络连接失败，请检查网络连接。");
        }
            break;
        case kCLErrorDenied:{
            alert_showErrMsg(@"定位服务未启用,请到隐私->定位服务->开启,否则定位无法完成.");
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:2 target:self
                                                                    selector:@selector(stopLocationDelayBy2Seconds)
                                                                    userInfo:nil
                                                                     repeats:NO];
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
//    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0)
    {
//        NSLog(@"Unable to get location, use the last known location");

        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
    
    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
        NSLog(@"authorizationStatus failed");
        alert_showErrMsg(@"定位服务未启用,请到隐私->定位服务->开启,否则定位无法完成.");
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict put:[NSNumber numberWithFloat:self.myLocation.latitude] key:@"latitude"];
    [dict put:[NSNumber numberWithFloat:self.myLocation.longitude] key:@"longitude"];
    NSNumber *time = [NSNumber numberWithDouble:[[SeverTimeManager defaultManager] currentTimeIntervarl]*1000];
    [dict put:time key:@"time"];
    [dict put:@"gps" key:@"type"];
    NSString *locationInfo = [dict JSONString];
    NSLog(@"jsonString:----%@",locationInfo);
    [[DBManager sharedManager] inserLocationWithLocationInfo:locationInfo];
    NSLog(@"locationsCount:-------->%ld",(unsigned long)[[DBManager sharedManager] readAllLocations].count);
}




@end
