//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"


@interface LocationTracker : NSObject <CLLocationManagerDelegate>
@property (nonatomic,assign) CLLocationCoordinate2D myLastLocation;
@property (nonatomic,assign) CLLocationAccuracy     myLastLocationAccuracy;
@property (strong,nonatomic) LocationShareModel     * shareModel;
@property (nonatomic,assign) CLLocationCoordinate2D myLocation;
@property (nonatomic,assign) CLLocationAccuracy     myLocationAccuracy;
@property (nonatomic, copy ) NSString               *addressName;
@property (nonatomic, assign) BOOL stopLoction;

+ (id)defaultLoactionTarker;
+ (CLLocationManager *)sharedLocationManager;
- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;


@end
