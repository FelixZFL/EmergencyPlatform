//
//  UserDetailViewController.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserDetailViewController.h"
#import "MineInfoCell.h"
#import "UserDetailTableCell.h"
#import "CallPhoneView.h"
#import "TeamUserDTO.h"

@interface UserDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TeamUserDTO *userModel;
@property (strong, nonatomic) CallPhoneView *callView;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableFooterView = self.callView;
    
    WeakSelf;
    self.callView.clickBtnslBlock = ^{
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",weakSelf.userModel.telephone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    };
    [self requestMineInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavView{
    self.navigationItem.title = @"详细资料";
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
- (CallPhoneView *)callView {
    if (!_callView) {
        _callView = [[CallPhoneView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _callView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _callView;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    } else {
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
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
    if (indexPath.section == 0) {
        static NSString *identifier = @"MineInfoCell";
        MineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:self.userModel];
        return cell;
    } else {
        static NSString *identifier = @"UserDetailTableCell";
        UserDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:indexPath.row user:self.userModel];
        return cell;
    }
}
- (void)requestMineInfo {
    if (!self.userID) {
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.userID forKey:@"userid"];
    
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



@end
