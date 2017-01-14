//
//  DriversMapViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/2.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "DriversMapViewController.h"
#import "RouteAnnotation.h"
#import "LocationTracker.h"
#import "GifAnnotationView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface DriversMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>{
    UILabel *_destanceLabel;
    UIButton * _locationButton;
}

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation* driverAnnotation;
@property (nonatomic, strong) BMKPointAnnotation* pickUpAnnotation;
@property (nonatomic, strong) BMKPointAnnotation* deliveryAnnotation;
@property (nonatomic, strong) BMKRouteSearch* routesearch;
@property (nonatomic, assign) BOOL isTransing;
@property (nonatomic, strong) TenderModel *tenderModel;
@end

@implementation DriversMapViewController


- (instancetype)initWithTenderModel:(TenderModel*)model{
    self = [super init];
    if (self) {
        self.tenderModel = model;
        if (model.execute_driver.current_location&&![model.status isEqualToString:@"completed"]) {
            self.isTransing = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self addBlackNaviHaderViewWithTitle:@"详情地图"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    [self initMapView];
}

- (void)initMapView{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _routesearch = [[BMKRouteSearch alloc]init];
    
    
    _destanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-200, 20, 180, 20)];
    _destanceLabel.font = [UIFont systemFontOfSize:16];
    _destanceLabel.backgroundColor = [UIColor clearColor];
    _destanceLabel.textAlignment = NSTextAlignmentRight;
    _destanceLabel.textColor = [UIColor customRedColor];
    [self.mapView addSubview:_destanceLabel];
    
    _locationButton = [[UIButton alloc]init];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"location_1"] forState:UIControlStateNormal];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"location_2"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(relocate) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_locationButton];
    
    _locationButton.sd_layout
    .bottomSpaceToView(self.mapView,20)
    .rightSpaceToView(self.mapView,20)
    .widthIs(22)
    .heightIs(22);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _locService.delegate = self;
    _mapView.delegate = self; 
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self addPickUpAndDeliveyRute];
    if (self.isTransing) {
        [self addDriverAnnotation];
    }
    [self addPickUpAnnotation];
    [self addDeliveryAnnotation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillDisappear];
    _locService.delegate = nil;
    _routesearch.delegate = nil;
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark --- > 地图代理回调

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    NSLog(@"%@ MapRegin\n%f \n%f", showmeg,mapView.region.span.latitudeDelta,mapView.region.span.latitudeDelta);
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate{
    CCLog(@"MapRegin\n%f \n%f",mapView.region.span.latitudeDelta,mapView.region.span.latitudeDelta);
}


#pragma mark ---- > 重新定位
- (void)relocate{
    //启动LocationService
    [_locService startUserLocationService];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    BMKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [_mapView setRegion:region animated:YES];
    [_locService stopUserLocationService];
}




#pragma mark ---- > 添加司机动画

- (void)addDriverAnnotation{
    if (self.driverAnnotation) {
        [_mapView removeAnnotation:self.driverAnnotation];
    }
    self.driverAnnotation = [[BMKPointAnnotation alloc]init];
    
    NSNumber *lat = self.tenderModel.execute_driver.current_location[1];
    NSNumber *lon = self.tenderModel.execute_driver.current_location[0];
    self.driverAnnotation.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
    self.driverAnnotation.title = @"货车位置";
    [_mapView addAnnotation:self.driverAnnotation];
}

- (void)addPickUpAnnotation{
    
    NSNumber *lat = self.tenderModel.pickup_region_location[1];
    NSNumber *lon = self.tenderModel.pickup_region_location[0];
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
    item.title = self.tenderModel.pickup_city;
    item.subtitle = self.tenderModel.pickup_region;
    item.type = RutoPickUp;
    [_mapView addAnnotation:item]; // 添加起点标注
    
}

- (void)addDeliveryAnnotation{
    NSNumber *lat = self.tenderModel.delivery_region_location[1];
    NSNumber *lon = self.tenderModel.delivery_region_location[0];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
    item.title = self.tenderModel.delivery_city;
    item.subtitle = self.tenderModel.delivery_region;
    item.type = RutoDelivery;
    [_mapView addAnnotation:item]; // 添加起点标注
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isEqual:self.driverAnnotation]) {
        //动画annotation
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        GifAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[GifAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        [annotationView showGifWithFileName:@"map_current"];
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:mapView];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark ---- > 路径规划

- (void)addPickUpAndDeliveyRute{
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
    if (self.isTransing) {
        NSNumber *startLat = self.tenderModel.execute_driver.current_location[1];
        NSNumber *startLon = self.tenderModel.execute_driver.current_location[0];
        start.pt = CLLocationCoordinate2DMake(startLat.floatValue,startLon.floatValue);
        
    }else{
        NSNumber *startLat = self.tenderModel.pickup_region_location[1];
        NSNumber *startLon = self.tenderModel.pickup_region_location[0];
        start.pt = CLLocationCoordinate2DMake(startLat.floatValue,startLon.floatValue);
        
    }
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    NSNumber *endLat = self.tenderModel.delivery_region_location[1];
    NSNumber *endLon = self.tenderModel.delivery_region_location[0];
    end.pt = CLLocationCoordinate2DMake(endLat.floatValue,endLon.floatValue);
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    drivingRouteSearchOption.drivingPolicy = BMK_DRIVING_DIS_FIRST;
    
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
//    NSArray* anarray = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:anarray];
    
    NSArray*linearray = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:linearray];

    NSInteger distance = 0;
    CLLocationCoordinate2D startlocation = CLLocationCoordinate2DMake(0, 0);
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
//            if(i==0){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.starting.location;
//                item.title = @"提货";
//                item.type = RutoPickUp;
//                [_mapView addAnnotation:item]; // 添加起点标注
//                
//            }else if(i==size-1){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.terminal.location;
//                item.title = @"交货";
//                item.type = RutoDelivery;
//                [_mapView addAnnotation:item]; // 添加起点标注
//            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = RutoPassPoint;
            [_mapView addAnnotation:item];
            CCLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
            
            if (startlocation.latitude!=0) {
                distance += [self getDistanceForLocation:startlocation toLocation:transitStep.entrace.location];
            }
            
            startlocation = transitStep.entrace.location;
            
        }
        
//        // 添加途经点
//        if (plan.wayPoints) {
//            for (BMKPlanNode* tempNode in plan.wayPoints) {
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item = [[RouteAnnotation alloc]init];
//                item.coordinate = tempNode.pt;
//                item.type = RutoPassPoint;
//                item.title = tempNode.name;
//                [_mapView addAnnotation:item];
//            }
//        }
    
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        NSString *tipString;
        if (self.isTransing) {
            tipString = @"剩余";
        }else{
            tipString = @"距离";
        }
        if (result.taxiInfo) {
            _destanceLabel.text = [NSString stringWithFormat:@"%@：%.2fKm",tipString,result.taxiInfo.distance/1000.00];
        }else{
            _destanceLabel.text = [NSString stringWithFormat:@"%@：%.2fKm",tipString,distance/1000.00];
        }
        [self mapViewFitPolyLine:polyLine];
    }
}

- (NSInteger)getDistanceForLocation:(CLLocationCoordinate2D)from toLocation:(CLLocationCoordinate2D)to{
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(from);
    BMKMapPoint point2 = BMKMapPointForCoordinate(to);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}

#pragma mark - 私有

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark ---> 返回 其他

- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
