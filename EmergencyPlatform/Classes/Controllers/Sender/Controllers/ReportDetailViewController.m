//
//  ReportDetailViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "ReportContentCell.h"
#import "ReportMesDTO.h"
#import "TeamUserDTO.h"
#import "XYAudioPlayer.h"
#import "ReportContentCell.h"

#import "XYAudioPlayer.h"
#import "SystemHelper.h"


@interface ReportDetailViewController ()<UITableViewDataSource,UITableViewDelegate,XYAudioPlayerDelegate>
@property (strong, nonatomic) NSMutableArray<ReportMesDTO *> *dataArray;

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIProgressView *ju_currentView;
@property (strong, nonatomic) TeamUserDTO *userModel;
@property (strong, nonatomic) UILabel *placeholderLabel;
@end

@implementation ReportDetailViewController
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
    [self setNavView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.tableView);
        make.center.equalTo(self.tableView);
    }];
    [self requestReport];
}
-(void)JuUpdateProgress{
    self.ju_currentView.progress=[XYAudioPlayer sharePlayer].juPlayCurrentTime/[XYAudioPlayer sharePlayer].juPlayTotalTime;
}
- (void)setNavView{
    self.navigationItem.title = @"上报内容详情";
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JuReportImageCell" bundle:nil] forCellReuseIdentifier:@"JuReportImageCell"];
    }
    return _tableView;
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = FONT_17;
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.textColor = COLOR_TEXT_GRAY;
        _placeholderLabel.text = @"暂无上报内容";
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}
- (NSMutableArray<ReportMesDTO *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    static NSString *identifier = @"ReportContentCell";
    ReportContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    [cell setCellDataWith:self.dataArray[indexPath.row]];
    cell.bgView.audioUrl = self.dataArray[indexPath.row].avi;
    return cell;
}
- (void)requestReport {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"notieID"];
    
    [NetWorkManager NetworkPOST:@"noticereport/getNoticereportbynotieID" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    
        NSMutableArray *dataArr = [ReportMesDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"]];
        [self.dataArray addObjectsFromArray:dataArr];
        self.placeholderLabel.hidden = self.dataArray.count > 0;
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
