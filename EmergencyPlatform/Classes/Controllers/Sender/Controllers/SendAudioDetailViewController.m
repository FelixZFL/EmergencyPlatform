//
//  SendAudioDetailViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/15.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SendAudioDetailViewController.h"
#import "ReportDetailViewController.h"
#import "NoticeTitleCell.h"
#import "NoticeCheckInStatusCell.h"
#import "AudioPlayCell.h"
#import "ReportBottomView.h"
#import "TeamUserDTO.h"
#import "UserInfoManager.h"
#import "XYAudioPlayer.h"
#import <CoreLocation/CoreLocation.h>
#import "NSObject+additions.h"
#import "UserDetailViewController.h"

#define kBottomViewHit  50
@interface SendAudioDetailViewController ()<UITableViewDataSource,UITableViewDelegate,XYAudioPlayerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ReportBottomView *bootomView;
@property (strong, nonatomic) ReceiveMesDTO *mesDetail;
@property (strong, nonatomic) TeamUserDTO *userModel;
@property (strong, nonatomic) NSMutableArray<TeamUserDTO *> *userArray;

@end

@implementation SendAudioDetailViewController

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
    
    WeakSelf;
    self.bootomView.clickBtnslBlock = ^() {
        //上报
        [weakSelf reportMes];
    };
    [self requestMineInfo];
    [self requestReceiveMesDetail];
}
- (void)setNavView{
    self.navigationItem.title = @"发送通知详情";
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.userArray.count;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 && self.userArray.count>0) {
        return 44;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2 && self.userArray.count>0) {
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
    if (indexPath.section ==0) {
        static NSString *identifier = @"NoticeTitleCell";
        NoticeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellUserDataWith:self.userModel];
        cell.centerName.hidden = YES;
        return cell;
    } else if (indexPath.section ==1) {
        static NSString *identifier = @"AudioPlayCell";
        AudioPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        cell.bagView.audioUrl = self.mesDetail.audio;

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
    if (indexPath.section == 2 && self.userArray.count > indexPath.row) {
        TeamUserDTO *user = self.userArray[indexPath.row];
        UserDetailViewController *vc = [[UserDetailViewController alloc] init];
        vc.userID = user.userID;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reportMes {
    ReportDetailViewController *controller = [[ReportDetailViewController alloc] init];
    controller.mesDto = self.mesDto;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
