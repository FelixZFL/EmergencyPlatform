//
//  AudioDetailViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/15.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AudioDetailViewController.h"
#import "SceneReportViewController.h"
#import "NoticeTitleCell.h"
#import "AudioPlayCell.h"
#import "ReportMesDTO.h"
#import "ReportContentCell.h"
#import "NoticeBottomView.h"
#import "TeamUserDTO.h"
#import "UserInfoManager.h"
#import "XYAudioPlayer.h"
#import <CoreLocation/CoreLocation.h>
#import "NSObject+additions.h"

#define kBottomViewHit  72
@interface AudioDetailViewController ()<UITableViewDataSource,UITableViewDelegate,XYAudioPlayerDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NoticeBottomView *bootomView;
@property (strong, nonatomic) ReceiveMesDTO *mesDetail;
@property (strong, nonatomic) TeamUserDTO *userModel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL locFired;  //是否停止获取位置
@property (copy, nonatomic) NSString *region_name;
@property (strong, nonatomic) ReportMesDTO *reportModel;
@end

@implementation AudioDetailViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //实现播放器代理
    [XYAudioPlayer sharePlayer].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止播放器
    [[XYAudioPlayer sharePlayer] stopAudioPlayer];
    //删除近距离事件监听（语音未播完界面变化时强制删除）
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bootomView];
    
    if (self.mesDto.arrive ==1) {
        self.bootomView.checkInBtn.enabled = NO;
        self.bootomView.checkInBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        self.bootomView.checkInBtn.titleLabel.font = FONT_18;
        [self.bootomView.checkInBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }
    if (self.mesDto.report == 1) {
        self.bootomView.reportBtn.enabled = NO;
        self.bootomView.reportBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        self.bootomView.reportBtn.titleLabel.font = FONT_18;
        [self.bootomView.reportBtn setTitle:@"已上报" forState:UIControlStateNormal];
    }
    WeakSelf;
    self.bootomView.clickBtnslBlock = ^(NSInteger tag) {
        if (tag == 0) {
            //签到
            [weakSelf deleteAlert];
        } else {
            if (weakSelf.mesDto.arrive !=1) {
                showFadeOutText(@"请先签到", 0, 3);
                return;
            }
            //上报
            [weakSelf reportMes];
        }
    };
    [self requestMineInfo];
    [self requestReceiveMesDetail];
    [self requestReport];
    [self startLocation];
}
- (void)setNavView{
    self.navigationItem.title = @"通知详情";
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomViewHit-kNav);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.allowsSelection=NO;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NoticeBottomView *)bootomView{
    if (!_bootomView) {
        _bootomView = [[NoticeBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kBottomViewHit-kNav, kScreenWidth, kBottomViewHit)];
        _bootomView.backgroundColor = [UIColor whiteColor];
    }
    return _bootomView;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2 && [NSObject dx_isNullOrNilWithObject:self.reportModel]) {
        return 0;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        static NSString *identifier = @"NoticeTitleCell";
        NoticeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellUserDataWith:self.userModel];
        cell.centerName.hidden = YES;
        return cell;
    } else if (indexPath.section ==1){
        static NSString *identifier = @"AudioPlayCell";
        AudioPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        cell.bagView.audioUrl = self.mesDetail.audio;
        return cell;
    }  else {
        static NSString *identifier = @"ReportContentCell";
        ReportContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:self.reportModel];
        cell.bgView.audioUrl = self.reportModel.avi;
        return cell;
    }
}
- (void)requestReceiveMesDetail {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"noticeid"];
    
    [NetWorkManager NetworkPOST:@"notice/getbyid" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        self.mesDetail = [ReceiveMesDTO mj_objectWithKeyValues:result[@"resultdata"]];
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)requestReport {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"notieID"];
    
    [NetWorkManager NetworkPOST:@"noticereport/getNoticereportbynotieID" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        NSMutableArray *dataArr = [ReportMesDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"]];
        if (dataArr.count ==0 ) {
            return;
        }
        self.reportModel = [[ReportMesDTO alloc] init];
        self.reportModel = dataArr[0];
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)requestMineInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userid"];
    
    [NetWorkManager NetworkPOST:@"user/getbyid" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        self.userModel = [TeamUserDTO mj_objectWithKeyValues:result[@"resultdata"]];
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)deleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定签到" message:@"请确定你已到达签到地点" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self signIn];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)signIn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"noticeID"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userID"];
    [params setObject:self.region_name forKey:@"address"];
    
    [NetWorkManager NetworkPOST:@"noticedept/arrive" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        self.mesDto.arrive = 1;
        showFadeOutText(@"签到成功", 0, 3);
        
        
        if (self.mesDto.arrive ==1) {
            self.bootomView.checkInBtn.enabled = NO;
            self.bootomView.checkInBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
            self.bootomView.checkInBtn.titleLabel.font = FONT_18;
            [self.bootomView.checkInBtn setTitle:@"已签到" forState:UIControlStateNormal];
        }
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
#pragma mark Location and Delegate
- (void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requestWhenInUseAuthorization");
        //        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    if (self.locFired) {
        return;
    }
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
          
            NSArray *lines = placeMark.addressDictionary[@"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@"\n"];
           
            self.region_name = [NSString stringWithFormat:@"%@",addressString];
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
    
    self.locFired = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reportMes {
    __weak __typeof(self)weakSelf = self;
    SceneReportViewController *controller = [[SceneReportViewController alloc] init];
    controller.mesDto = self.mesDto;
    [controller setReportSuccessBlock:^{
        weakSelf.mesDto.report = 1;
        weakSelf.bootomView.reportBtn.enabled = NO;
        weakSelf.bootomView.reportBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        weakSelf.bootomView.reportBtn.titleLabel.font = FONT_18;
        [weakSelf.bootomView.reportBtn setTitle:@"已上报" forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}
@end