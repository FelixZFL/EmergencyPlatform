//
//  MapLocationViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MapLocationViewController.h"
#import<BaiduMapAPI_Map/BMKMapView.h>
#import<BaiduMapAPI_Location/BMKLocationService.h>
#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import<BaiduMapAPI_Map/BMKMapComponent.h>
#import<BaiduMapAPI_Search/BMKPoiSearchType.h>

@interface MapLocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;  //地图
    BMKLocationService *_locService;  //定位
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
    BMKPinAnnotationView *newAnnotation;
    BMKPointAnnotation *ju_collectionAnnotation;
}
@property (copy, nonatomic) NSString *strAddress;
@property (strong, nonatomic) AddressDTO *address;

@property (nonatomic, assign) CLLocationCoordinate2D userCoor;
@property (nonatomic, copy) NSString *userAddress;

@end

@implementation MapLocationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)setNavView{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(navigationAction:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_20} forState:UIControlStateNormal];
    self.title = _ju_collectTitle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    
    self.address = [[AddressDTO alloc] init];
    
    //添加地图视图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNav)];
    
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    
    _mapView.zoomLevel = 19;//地图显示比例
    
    _mapView.mapType = BMKMapTypeStandard;//设置地图为空白类型
    
    [self.view addSubview:_mapView];
    

    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    _geocodesearch.delegate = self;
    
    [self startLocation];//开始定位方法
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [_mapView addGestureRecognizer:mTap];

    if (_ju_location2D.latitude==0) {
        [self.view addSubview:self.locationMap];
        [self.locationMap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(20);
        }];
    }else{
        [self addPointAnnotation];
    }
   
}
- (UIImageView *)locationMap {
    if (!_locationMap) {
        _locationMap = [[UIImageView alloc] init];
        _locationMap.image = [UIImage imageNamed:@"map_dingwei"];
    }
    return _locationMap;
}
- (void)addPointAnnotation
{
    if (ju_collectionAnnotation == nil) {
        ju_collectionAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = _ju_location2D.latitude;
        coor.longitude =_ju_location2D.longitude;
        ju_collectionAnnotation.coordinate = coor;
        ju_collectionAnnotation.title = @"集合点";
        ju_collectionAnnotation.subtitle = _ju_collectTitle;
         _mapView.centerCoordinate = coor; //更新当前位置到地图中间
    }
    [_mapView addAnnotation:ju_collectionAnnotation];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
}
//开始定位
-(void)startLocation{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //启动LocationService
    
    [_locService startUserLocationService];
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"我是小猪");
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.address.lat = userLocation.location.coordinate.latitude;
    self.address.lng = userLocation.location.coordinate.longitude;
    
    //以下_mapView为BMKMapView对象
    self.userCoor = userLocation.location.coordinate;
    self.userAddress = userLocation.title;

    [_mapView updateLocationData:userLocation]; //更新地图上的位置
//    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间

    if (_ju_location2D.longitude==0) {
        _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    }
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    self.address.lat = centerCoordinate.latitude;
    self.address.lng = centerCoordinate.longitude;
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = centerCoordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}
#pragma mark -------------地理反编码的delegate---------------
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    self.strAddress = result.address;
    self.address.address = result.address;;
    NSLog(@"我的地址:%@----%@",result.addressDetail,result.address);
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        // 设置颜色
        ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    
    newAnnotation.centerOffset = CGPointMake(0, -(newAnnotation.frame.size.height * 0.5));
    newAnnotation.annotation = annotation;
    [newAnnotation setSelected:YES animated:YES];
    return newAnnotation;
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}
- (void)submitAction:(id)sender{
    if (self.refreshAddressBlock) {
        self.refreshAddressBlock(self.address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationAction:(id)sender {
    if (!self.userAddress) {
        return;
    }
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"导航" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionSheet addAction:cancelAction];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving";
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,
                                    self.userCoor.latitude,
                                    self.userCoor.longitude,
                                    self.ju_location2D.latitude,
                                    self.ju_location2D.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:baiduMapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]]) {
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *gaodeParameterFormat = @"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2";
            NSString *urlString = [[NSString stringWithFormat:
                                    gaodeParameterFormat,
                                    @"yourAppName",
                                    @"yourAppUrlSchema",
                                    self.addressName,
                                    self.ju_location2D.latitude,
                                    self.ju_location2D.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:gaodeMapAction];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //终点
        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake(self.ju_location2D.latitude, self.ju_location2D.longitude);
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
        //默认驾车
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],
                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://map/"]]) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *QQParameterFormat = @"qqmap://map/routeplan?type=drive&fromcoord=%f, %f&tocoord=%f,%f&coord_type=1&policy=0&refer=%@";
            NSString *urlString = [[NSString stringWithFormat:
                                    QQParameterFormat,
                                    self.userCoor.latitude,
                                    self.userCoor.longitude,
                                    self.ju_location2D.latitude,
                                    self.ju_location2D.longitude,
                                    @"yourAppName"]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }]];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
