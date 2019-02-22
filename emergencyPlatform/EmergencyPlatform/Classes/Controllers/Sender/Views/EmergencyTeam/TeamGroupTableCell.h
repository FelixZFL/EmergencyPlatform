//
//  TeamGroupTableCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "XYEdgeInsetsButton.h"
#import "TeamDeptDTO.h"
#import "TeamUserDTO.h"

typedef void(^UserSelectBlock)(TeamUserDTO *user);
@interface TeamGroupTableCell : BaseTableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) XYEdgeInsetsButton *selectTeamBtn;
@property (strong, nonatomic) UIButton *selectbtn;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void (^teamBtnClickBlock)(TeamGroupTableCell *groupCell);
@property (strong, nonatomic) TeamDeptDTO *team;

@property (copy, nonatomic)UserSelectBlock userSelectBlock;
- (void)setCellDataWith:(TeamDeptDTO *)data;
@end
