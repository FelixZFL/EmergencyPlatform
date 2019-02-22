//
//  EmergencyTeamViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "EmergencyTeamViewController.h"
#import "SendMesDetailViewController.h"
#import "AudioCallViewController.h"
#import "TeamHeaderView.h"
#import "SendMesListCell.h"
#import "TeamGroupTableCell.h"
#import "EmergencyBottomView.h"
#import "SearchTextView.h"
#import "XYCategoryMenu.h"
#import "TeamDeptDTO.h"
#import "TeamUserDTO.h"

#define kBottomViewHit  50
@interface EmergencyTeamViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) EmergencyBottomView *bottomView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SearchTextView *searchText;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray<TeamDeptDTO *> *arrLevel0;
@property (strong, nonatomic) NSMutableArray<TeamDeptDTO *> *arrLevel1;  //院内院外
@property (assign, nonatomic) NSInteger index;

@end

@implementation EmergencyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    [self.view addSubview:self.searchText];
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.searchText.mas_bottom).offset(0);
        make.height.mas_equalTo(kScreenHeight-kBottomViewHit-kBottomViewHit-kNav);
    }];
    
    [self requestTeamInfo];
    WeakSelf;
    self.bottomView.clickBtnslBlock = ^(NSInteger tag) {
        [weakSelf gotoSendMesDetail:tag];
    };
}
- (void)setNavView{
    self.navigationItem.title = @"应急组";
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:NSClassFromString(@"TeamHeaderView") forHeaderFooterViewReuseIdentifier:@"TeamHeaderView"];
    }
    return _tableView;
}
- (EmergencyBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[EmergencyBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kBottomViewHit-kNav, kScreenWidth, kBottomViewHit)];
    }
    return _bottomView;
}
- (SearchTextView *)searchText {
    if (!_searchText) {
        _searchText = [[SearchTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBottomViewHit)];
        _searchText.backgroundColor = [UIColor whiteColor];
        _searchText.textField.backgroundColor = BACKGROUNDCOLOR;
        _searchText.textField.delegate = self;
    }
    return _searchText;
}
- (NSMutableArray<TeamDeptDTO *> *)arrLevel0{
    if (!_arrLevel0) {
        _arrLevel0 = [NSMutableArray array];
    }
    return _arrLevel0;
}
- (NSMutableArray<TeamDeptDTO *> *)arrLevel1{
    if (!_arrLevel1) {
        _arrLevel1 = [NSMutableArray array];
    }
    return _arrLevel1;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { return NO;}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField*)textField{
    [textField resignFirstResponder];
    WeakSelf;
    [XYCategoryMenu setSelectedColor:[UIColor blackColor]];
    [XYCategoryMenu showMenuInView:weakSelf.view fromRect:CGRectMake(kScreenWidth - 88, 0, 78, 0) menuItems:weakSelf.items selected:^(NSInteger index, XYMenuItem *item) {
        weakSelf.index = index;
        
        weakSelf.searchText.textField.text = item.title;
        TeamDeptDTO *model = self.arrLevel0[0].subDept[index];
        [weakSelf.arrLevel1 removeAllObjects];
        [weakSelf.arrLevel1 addObjectsFromArray:model.subDept];
        
        [self.tableView reloadData];
    }];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrLevel1.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TeamDeptDTO *model = self.arrLevel1[section];
    if (model.isOpened) {
        return self.arrLevel1[section].subDept.count;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TeamHeaderView getTeamHeaderHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TeamHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TeamHeaderView"];
    headerView.topView.backgroundColor = COLOR_TEXT_LIGHTGRAY;
//    [headerView.selectTeamBtn setTitle:self.arrLevel1[section].deptName forState:UIControlStateNormal];
    [headerView setModel:self.arrLevel1[section]];
    [headerView setTeamBtnClickBlock:^{
        [self.tableView reloadData];
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TeamGroupTableCell";
    TeamGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[TeamGroupTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TeamDeptDTO *teamModel = self.arrLevel1[indexPath.section].subDept[indexPath.row];
    [cell setCellDataWith:teamModel];
    [cell setTeamBtnClickBlock:^(TeamGroupTableCell *groupCell) {
        
        NSIndexPath *cellOfIndexP = [tableView indexPathForCell:groupCell];
        [self.tableView reloadRowsAtIndexPaths:@[cellOfIndexP] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    WEAK
    [[[cell.selectbtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        
        TeamDeptDTO *model = self.arrLevel1[indexPath.section].subDept[indexPath.row];
        model.isAllSelect = !model.isAllSelect;
        x.selected = model.isAllSelect;
        for (TeamUserDTO *user in model.user) {
            user.isSelected = model.isAllSelect;
        }
        
        [self.tableView reloadData];

    }];
    cell.userSelectBlock = ^(TeamUserDTO *user) {

        [self.tableView reloadData];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)requestTeamInfo {
    [NetWorkManager NetworkPOST:@"dept/getDeptbyorgID" parameters:nil startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        NSMutableArray *dataArr = [TeamDeptDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"]];
        [self.arrLevel0 addObjectsFromArray:dataArr];
        self.items = [[NSMutableArray alloc] init];
        NSInteger i = 0;
        for (TeamDeptDTO *item in self.arrLevel0[0].subDept) {
            XYMenuItem *model = [XYMenuItem menuItem:item.deptName image:nil tag:i userInfo:@{@"title":@"Menu"}];
            [self.items addObject:model];
            i++;
        }
        //默认取值
        TeamDeptDTO *model = self.arrLevel0[0].subDept[0];
        self.searchText.textField.text = model.deptName;
        [self.arrLevel1 addObjectsFromArray:model.subDept];
        
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)gotoSendMesDetail:(NSInteger)tag {
    
    
    NSMutableArray *userArray = [NSMutableArray arrayWithCapacity:1];
    
    for (TeamDeptDTO *sectionTeam in self.arrLevel1) {
        
        for (TeamDeptDTO *rowTeam in sectionTeam.subDept) {
            
            for (TeamUserDTO *user in rowTeam.user) {
                
                if (user.isSelected) {
                    
                    [userArray addObject:user];
                }
                
            }
        }
        
    }
    
    //1|2@1|4
    __block NSString *paraString = @"";
    __block NSString *nameString = @"";
    [userArray enumerateObjectsUsingBlock:^(TeamUserDTO *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == userArray.count-1) {
            paraString = [paraString stringByAppendingFormat:@"%@|%@",obj.deptID,obj.userID];
            nameString = [nameString stringByAppendingFormat:@"%@",obj.userName];
        }else {
            paraString = [paraString stringByAppendingFormat:@"%@|%@@",obj.deptID,obj.userID];
            nameString = [nameString stringByAppendingFormat:@"%@,",obj.userName];
        }
    }];
    
    if (paraString.length == 0) {
        return;
    }
    
    if (tag ==1) {
        SendMesDetailViewController *controller = [[SendMesDetailViewController alloc] init];
        controller.userNameStr = nameString;
        controller.paraString = paraString;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        AudioCallViewController *controller = [[AudioCallViewController alloc] init];
        controller.userNameStr = nameString;
        controller.paraString = paraString;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
