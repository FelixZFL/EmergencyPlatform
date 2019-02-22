//
//  TeamGroupTableCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TeamGroupTableCell.h"
#import "memberCell.h"

@implementation TeamGroupTableCell

- (void)setupSubviews{
    [self.contentView addSubview:self.selectTeamBtn];
    [self.selectTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(44);
        make.height.mas_equalTo(44);
    }];
    [self.contentView addSubview:self.selectbtn];
    [self.selectbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectTeamBtn.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.mas_equalTo(44);
    }];
}
- (XYEdgeInsetsButton *)selectTeamBtn {
    if (!_selectTeamBtn) {
        _selectTeamBtn = [XYEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        [_selectTeamBtn setImage:[UIImage imageNamed:@"dooble_arrow_right"]
                        forState:UIControlStateNormal];
        [_selectTeamBtn setImage:[UIImage imageNamed:@"dooble_arrow_down"]
                        forState:UIControlStateSelected];
        [_selectTeamBtn setTitleColor:COLOR_TEXT_LIGHTGRAY
                             forState:UIControlStateNormal];
        _selectTeamBtn.titleLabel.font = FONT_BOLD_14;
        [_selectTeamBtn setEdgeInsetsStyle:HYButtonEdgeInsetsStyleImageLeft];
        _selectTeamBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selectTeamBtn addTarget:self action:@selector(teamBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectTeamBtn setImageTitleSpace:15];
    }
    return _selectTeamBtn;
}
- (UIButton *)selectbtn {
    if (!_selectbtn) {
        _selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectbtn setImage:[UIImage imageNamed:@"btn_unSelected"]
                        forState:UIControlStateNormal];
        [_selectbtn setImage:[UIImage imageNamed:@"btn_selected"]
                        forState:UIControlStateSelected];
    }
    return _selectbtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_SEPARATE;
    }
    return _lineView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)setCellDataWith:(TeamDeptDTO *)data {
    self.team = data;
    
    self.selectbtn.selected = data.isAllSelect;
    [self.selectTeamBtn setTitle:data.deptName forState:UIControlStateNormal];
    
    [self updateTableView];
}

- (void)updateTableView {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.team.isOpened) {
            make.height.mas_equalTo(44 * self.team.user.count);
        }else {
            make.height.mas_equalTo(0);
        }
    }];
    [self layoutIfNeeded];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.team.isOpened) {
        return self.team.user.count;
    }else {
        return 0;
    }
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
    static NSString *identifier = @"memberCell";
    memberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    [cell setCellDataWith:self.team.user[indexPath.row]];
//    if (self.team.isAllSelect) {
//        cell.selectedBtn.selected = YES;
//    } else {
//        cell.selectedBtn.selected = NO;
//    }
    WEAK
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        cell.user.isSelected = !cell.user.isSelected;
        x.selected = cell.user.isSelected;
        
        NSInteger selectCount = 0;
        for (TeamUserDTO *user in self.team.user) {
            if (user.isSelected == YES) {
                selectCount += 1;
            }
        }
        
        if (selectCount == self.team.user.count) {
            self.team.isAllSelect = YES;
        }else {
            self.team.isAllSelect = NO;
        }
        
        
        if (self.userSelectBlock) {
            self.userSelectBlock(self.team.user[indexPath.row]);
        }
    }];
    return cell;
}

- (void)teamBtnClickAction:(UIButton *)sender {
    self.team.isOpened = !self.team.isOpened;
    if (self.teamBtnClickBlock) {
        self.teamBtnClickBlock(self);
    }
}

@end
