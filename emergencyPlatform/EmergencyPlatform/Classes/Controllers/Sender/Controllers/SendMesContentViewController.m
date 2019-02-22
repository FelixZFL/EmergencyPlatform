//
//  SendMesContentViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SendMesContentViewController.h"
#import "MapLocationViewController.h"
#import "ReportDetailViewController.h"
#import "NoticeTitleCell.h"
#import "NoticeContentCell.h"
#import "NoticeEventCell.h"
#import "NoticeCheckInCell.h"
#import "NoticeCheckInStatusCell.h"
#import "ReportBottomView.h"
#import "ReceiveMesDTO.h"
#import "UserInfoManager.h"
#import "ReportMesDTO.h"
#import "TeamUserDTO.h"
#import "ReportContentCell.h"
#import <CoreLocation/CoreLocation.h>
#import "NSObject+additions.h"
#import "UserDetailViewController.h"

#define kBottomViewHit  50
@interface SendMesContentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ReportBottomView *bootomView;
@property (strong, nonatomic) ReceiveMesDTO *mesDetail;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL locFired;  //是否停止获取位置
@property (copy, nonatomic) NSString *currentProvince;          //省
@property (copy, nonatomic) NSString *currentCity;              //当前城市
@property (copy, nonatomic) NSString *currentSubLocality;       //区
@property (copy, nonatomic) NSString *region_name;
@property (strong, nonatomic) ReportMesDTO *reportModel;
@property (strong, nonatomic) NSMutableArray<TeamUserDTO *> *userArray;
@property (strong, nonatomic) UILabel *placeholderLabel;
@end

@implementation SendMesContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.placeholderLabel];
    [self.view addSubview:self.bootomView];
    
    WeakSelf;
    self.bootomView.clickBtnslBlock = ^() {
            //上报
        [weakSelf reportMes];
    };
    
    [self requestReceiveMesDetail];
}
- (void)setNavView{
    self.navigationItem.title = @"发送通知详情";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomViewHit-kNav);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        _placeholderLabel.font = FONT_17;
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.textColor = COLOR_TEXT_GRAY;
        _placeholderLabel.text = @"暂无通知内容";
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}
- (NSMutableArray<TeamUserDTO *> *)userArray{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (ReportBottomView *)bootomView{
    if (!_bootomView) {
        _bootomView = [[ReportBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kBottomViewHit-kNav, kScreenWidth, kBottomViewHit)];
        _bootomView.backgroundColor = [UIColor whiteColor];
    }
    return _bootomView;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.userArray.count;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 && self.userArray.count>0) {
        return 44;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3 && self.userArray.count>0) {
        UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        headerLbl.backgroundColor = [UIColor whiteColor];
        headerLbl.textColor = COLOR_COMMONRED;
        headerLbl.font = FONT_14;
        headerLbl.text = @"  通知状态";
        
        return headerLbl;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"NoticeTitleCell";
        NoticeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:self.mesDetail];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"NoticeContentCell";
        NoticeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [[[cell.ju_location rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            NSIndexPath *indexP = [tableView indexPathForCell:cell];
            [self gotToLocationMap:indexP.section];
        }];
        [cell setCellDataWith:self.mesDetail];
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"NoticeEventCell";
        NoticeEventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [[[cell.ju_btnLoction rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            NSIndexPath *indexP = [tableView indexPathForCell:cell];
            [self gotToLocationMap:indexP.section];
        }];
        [cell setCellDataWith:self.mesDetail];
        return cell;
    } else {
        static NSString *identifier = @"NoticeCheckInStatusCell";
        NoticeCheckInStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:self.userArray[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && self.userArray.count > indexPath.row) {
        TeamUserDTO *user = self.userArray[indexPath.row];
        UserDetailViewController *vc = [[UserDetailViewController alloc] init];
        vc.userID = user.userID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotToLocationMap:(NSInteger)section {
    MapLocationViewController *controller = [[MapLocationViewController alloc] init];
    if (section == 1) {//集合地点
        controller.ju_location2D=CLLocationCoordinate2DMake(self.mesDetail.aggregateLat.doubleValue, self.mesDetail.aggregateLng.doubleValue);
        controller.addressName = self.mesDetail.aggregateaddress;
        controller.ju_collectTitle=@"集合地点";
    }else {//发生地点
        controller.ju_location2D=CLLocationCoordinate2DMake(self.mesDetail.lat.doubleValue, self.mesDetail.lng.doubleValue);
        controller.addressName = self.mesDetail.address;
        controller.ju_collectTitle=@"发生地点";
    }
      controller.ju_location2D=CLLocationCoordinate2DMake(self.mesDetail.aggregateLat.doubleValue, self.mesDetail.aggregateLng.doubleValue);
     controller.ju_collectTitle=self.mesDetail.aggregateaddress;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)requestReceiveMesDetail {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"noticeid"];
    
    [NetWorkManager NetworkPOST:@"notice/getsendbyid" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        self.mesDetail = [ReceiveMesDTO mj_objectWithKeyValues:result[@"resultdata"]];
        
        NSMutableArray *dataArr = [TeamUserDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"][@"users"]];
        [self.userArray addObjectsFromArray:dataArr];
        self.placeholderLabel.hidden = self.userArray.count > 0;
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)reportMes {
    ReportDetailViewController *controller = [[ReportDetailViewController alloc] init];
    controller.mesDto = self.mesDto;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
