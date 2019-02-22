//
//  MapChooseAddressViewController.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MapChooseAddressViewController.h"
#import<BaiduMapAPI_Map/BMKMapView.h>
#import<BaiduMapAPI_Location/BMKLocationService.h>
#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import<BaiduMapAPI_Map/BMKMapComponent.h>
#import "AddressDTO.h"


/**
 地址列表Cell
 */
@interface AddressListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *selectImageV; // 勾选图标
@property (nonatomic, strong) UILabel *nameLabel; // 名字
@property (nonatomic, strong) UILabel *addressLabel; // 地址
@property (nonatomic, strong) UIView *lineView; // 分割线
@end

@implementation AddressListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.selectImageV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.lineView];
        
        [self layoutSubviews];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak __typeof(self)weakSelf = self;
    [self.selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.equalTo(weakSelf.selectImageV.mas_left);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(15);
        make.right.equalTo(weakSelf.selectImageV.mas_left);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(.5);
    }];
}
#pragma mark - 初始化各View
- (UIImageView *)selectImageV
{
    if (_selectImageV == nil) {
        _selectImageV = [[UIImageView alloc] init];
        _selectImageV.contentMode = UIViewContentModeCenter;
    }
    return _selectImageV;
}
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor grayColor];
    }
    return _nameLabel;
}
- (UILabel *)addressLabel
{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = [UIColor lightGrayColor];
    }
    return _addressLabel;
}
- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}
@end



@interface MapChooseAddressViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BMKLocationService *_locService;  //定位
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
    BMKPoiSearch * _bMKPoiSearch; //POI搜索
    BOOL showSearchTable;//是否显示
}
@property (nonatomic, strong) BMKMapView *mapView;//地图
@property (nonatomic, strong) UITableView *tableView;// 反地理编码地址列表
@property (nonatomic, strong) UITableView *searchTableView; //地址搜索 地址列表
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;//菊花指示器

@property (nonatomic, strong) NSMutableArray *reGeoArray;//反地理编码结果数组
@property (nonatomic, strong) NSMutableArray *poiArray;//地址搜索结果数组

@property (nonatomic, strong) BMKPoiInfo *currectPoiInfo;//当前选中地址
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//反地理编码列表 选中的行数
//@property (nonatomic, strong) UISearchBar *searchBar;//搜索框
@property (nonatomic, strong) UITextField *searchBar;//搜索框
@end

@implementation MapChooseAddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    [self setNavView];
    
    //初始化ui
    [self setupUI];
    
    //初始化地理编码搜索
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    //初始化POI搜索
    _bMKPoiSearch = [[BMKPoiSearch alloc] init];
    _bMKPoiSearch.delegate = self;
    
    //开始定位方法
    [self startLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航栏
- (void)setNavView{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_20} forState:UIControlStateNormal];
    [self.navigationItem setTitleView:self.searchBar];
}
#pragma mark - UI
- (void)setupUI {
    //y坐标设置为0 导航栏下
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, (kScreenHeight-kNav)/2.f)];
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    _mapView.zoomLevel = 19;//地图显示比例
    _mapView.mapType = BMKMapTypeStandard;//设置地图类型
    [self.view addSubview:_mapView];
    [self hiddenBaiDuMapLogo];
    
    [_mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapAction:)]];
    
    
    __weak __typeof(self)weakSelf = self;
    UIImageView *locationMap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_dingwei"]];
    [self.mapView addSubview:locationMap];
    [locationMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mapView.mas_centerX);
        make.centerY.equalTo(weakSelf.mapView.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(20);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(weakSelf.mapView.mas_bottom);
    }];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    _activityIndicator.color = [UIColor grayColor];
    [self.tableView addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.centerX.equalTo(weakSelf.tableView.mas_centerX);
        make.centerY.equalTo(weakSelf.tableView.mas_centerY);
    }];
    
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _searchTableView.showsVerticalScrollIndicator = NO;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.hidden = YES;
    [self.view addSubview:_searchTableView];
    [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
}
#pragma mark - private
//隐藏地图上百度logo
- (void)hiddenBaiDuMapLogo{
    UIView *mView = _mapView.subviews.firstObject;
    for (id logoView in mView.subviews)  {
        if ([logoView isKindOfClass:[UIImageView class]])      {
            UIImageView *b_logo = (UIImageView*)logoView;
            b_logo.hidden = YES;
        }
    }
}

- (void)mapTapAction:(UITapGestureRecognizer *)tap {
    [self.searchBar resignFirstResponder];
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

/**
 *发送地理编码请求
 *@see reverseGeoCode
 */
- (void)getLocationStringByLocationCoordinate:(CLLocationCoordinate2D)coordinate {
    //发起地理编码
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BMKReverseGeoCodeOption *co = [[BMKReverseGeoCodeOption alloc] init];
    co.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:co];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
}

//搜索
- (void)searchContentForSearchText:(NSString*)searchText {
    BMKCitySearchOption * option = [[BMKCitySearchOption alloc] init];
    option.city = self.currectPoiInfo.city;
    option.keyword = searchText;
    [_bMKPoiSearch poiSearchInCity:option];
}

//隐藏搜索结果列表
- (void)hiddenSearchTabelView {
    [self.searchBar resignFirstResponder];
    [self.poiArray removeAllObjects];
    [self.searchTableView reloadData];
    showSearchTable = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.searchTableView.alpha = 0;
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchTableView.hidden = YES;
        }
    }];
}

- (void)textFieldDidChange:(UITextField *)sender {
    
    if (sender.markedTextRange != nil) {
        return;
    }
    [self.poiArray removeAllObjects];
    UITextField *_field = (UITextField *)sender;
    NSString *str = _field.text;
    
    if (str.length == 0) {
        [self hiddenSearchTabelView];
    }else {
        [self searchContentForSearchText:str];
        if (!showSearchTable) {
            showSearchTable = YES;
            self.searchTableView.alpha = 0;
            self.searchTableView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.alpha = 0;
                self.searchTableView.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.searchTableView reloadData];
                }
            }];
        }else {
            [self.searchTableView reloadData];
        }
    }
}

- (void)submitAction:(id)sender{
    if (self.currectPoiInfo && self.refreshAddressBlock) {
        AddressDTO  *address = [[AddressDTO alloc] init];
        address.lat = self.currectPoiInfo.pt.latitude;
        address.lng = self.currectPoiInfo.pt.longitude;
        address.address = self.currectPoiInfo.address;
        self.refreshAddressBlock(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.reGeoArray.count;
    }else {
        return self.poiArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier = @"AddressListCell";
    AddressListCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.tableView) {
        BMKPoiInfo *poi = self.reGeoArray[indexPath.row];
        cell.nameLabel.text = poi.name;
        cell.addressLabel.text = poi.address;
        cell.selectImageV.image = [UIImage imageNamed:self.selectedIndexPath.row == indexPath.row ? @"icon_address_choosed" : @""];
    }else {//icon_address_choosed
        BMKPoiInfo *poi = self.poiArray[indexPath.row];
        cell.nameLabel.text = poi.name;
        cell.addressLabel.text = poi.address;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        if (self.selectedIndexPath.row == indexPath.row) {
            return;
        }
        NSIndexPath * temp = [self.selectedIndexPath copy];
        self.selectedIndexPath = [indexPath copy];
        self.currectPoiInfo = [self.reGeoArray objectAtIndex:indexPath.row];
        self.searchBar.text = self.currectPoiInfo.address;
        [tableView reloadRowsAtIndexPaths:@[temp, indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        self.currectPoiInfo = [self.poiArray objectAtIndex:indexPath.row];
        _mapView.zoomLevel = 19;
        BMKCoordinateRegion region = _mapView.region;
        region.center = self.currectPoiInfo.pt;
        [_mapView setRegion:region animated:YES];
        [self getLocationStringByLocationCoordinate:self.currectPoiInfo.pt];
        self.searchBar.text = self.currectPoiInfo.address;
        [self hiddenSearchTabelView];
    }
}


#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    //地理反编码
    [self getLocationStringByLocationCoordinate:userLocation.location.coordinate];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    //地理反编码
    [self getLocationStringByLocationCoordinate:centerCoordinate];
}

#pragma mark -------------BMKGeoCodeSearchDelegate 地理反编码的delegate---------------
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    [self.activityIndicator stopAnimating];
    if (!self.currectPoiInfo) {
        self.currectPoiInfo = [[BMKPoiInfo alloc] init];
    }
    
    self.currectPoiInfo = result.poiList[0];
    self.searchBar.text = self.currectPoiInfo.address;
    
    [self.reGeoArray removeAllObjects];
    [self.reGeoArray addObjectsFromArray:result.poiList];
    [self.tableView reloadData];
    
    NSLog(@"我的地址:%@----%@",result.addressDetail,result.address);
}

#pragma mark -------------BMKPoiSearchDelegate 搜索poi的delegate---------------
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    [self.poiArray removeAllObjects];
    if (showSearchTable) {
        [self.poiArray addObjectsFromArray:poiResult.poiInfoList];
    }
    [self.searchTableView reloadData];
}

#pragma mark - getter
- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"地址搜索";
        _searchBar.font = [UIFont systemFontOfSize:14];
        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBar.borderStyle = UITextBorderStyleRoundedRect;
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchBar;
}

- (NSMutableArray *)reGeoArray {
    if (!_reGeoArray) {
        _reGeoArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _reGeoArray;
}
- (NSMutableArray *)poiArray {
    if (!_poiArray) {
        _poiArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _poiArray;
}

@end
