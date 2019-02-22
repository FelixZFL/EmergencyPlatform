//
//  SendMesViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SendMesViewController.h"
#import "SendAudioDetailViewController.h"
#import "SendMesDetailViewController.h"
#import "EmergencyTeamViewController.h"
#import "SendMesContentViewController.h"
#import "SendMesListCell.h"
#import "SendMesAudioCell.h"
#import "UserInfoManager.h"
#import "ReceiveMesDTO.h"
#import "MJRefresh.h"

@interface SendMesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger page_index;  //分页
@property (assign, nonatomic) NSInteger pagesize;
@property (strong, nonatomic) NSMutableArray<ReceiveMesDTO *> *dataArray;
@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation SendMesViewController
- (BOOL)needShowBackButton {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    self.page_index = 1;
    self.pagesize = 20;
    [self requestSendMesList];
    
    [self addHeader];
    [self addFooter];
}
- (void)setNavView{
    self.navigationItem.title = @"发送通知列表";
    [self.rightBtn1 setImage:[UIImage imageNamed:@"emergency_team"] forState:UIControlStateNormal];
    [self.rightBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn1];
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
    }
    return _tableView;
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = FONT_17;
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.textColor = COLOR_TEXT_GRAY;
        _placeholderLabel.text = @"暂未发送通知";
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}
- (NSMutableArray<ReceiveMesDTO *> *)dataArray{
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
    ReceiveMesDTO *model = self.dataArray[indexPath.row];
    if (model.classic == 0) {
        static NSString *identifier = @"SendMesListCell";
        SendMesListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:self.dataArray[indexPath.row]];
        return cell;
    } else {
        static NSString *identifier = @"SendMesAudioCell";
        SendMesAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:model];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveMesDTO *model = self.dataArray[indexPath.row];
    if (model.classic == 0) {
        [self gotoMesDetail:model];
    } else {
        [self gotoAudioDetail:model];
    }
}
- (void)requestSendMesList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userID"];
    [params setObject:@(self.page_index) forKey:@"pageindex"];
    [params setObject:@(self.pagesize) forKey:@"pagesize"];
    
    [NetWorkManager NetworkPOST:@"notice/getsendlist" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        if (self.page_index == 1) {
            [self.dataArray removeAllObjects];
        }
        NSMutableArray *dataArr = [ReceiveMesDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"]];
        [self.dataArray addObjectsFromArray:dataArr];
        if (dataArr.count < 20) {
            [self.tableView setFooterHidden:YES];
        } else {
            [self.tableView setFooterHidden:NO];
        }
        self.page_index += 1;
        self.placeholderLabel.hidden = self.dataArray.count > 0;
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
//下拉刷新
- (void)addHeader{
    __unsafe_unretained typeof(self) vc = self;
    //添加下拉刷新头部控件
    [self.tableView addHeaderWithCallback:^{
        vc.page_index = 1;
        [vc requestSendMesList];
    }];
}
//上拉加载更多
- (void)addFooter{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addFooterWithCallback:^{
        [vc requestSendMesList];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
- (void)clickRightBtn1 {
    EmergencyTeamViewController *controller = [[EmergencyTeamViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoSendMesDetail {
    SendMesDetailViewController *controller = [[SendMesDetailViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoMesDetail:(ReceiveMesDTO *)model {
    SendMesContentViewController *controller = [[SendMesContentViewController alloc] init];
    controller.mesDto = model;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoAudioDetail:(ReceiveMesDTO *)model {
    SendAudioDetailViewController *controller = [[SendAudioDetailViewController alloc] init];
    controller.mesDto = model;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
