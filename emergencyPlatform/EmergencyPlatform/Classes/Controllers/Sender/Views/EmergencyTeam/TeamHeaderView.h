//
//  TeamHeaderView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseTableHeaderFooterView.h"
#import "XYEdgeInsetsButton.h"

@class TeamDeptDTO;

@interface TeamHeaderView : BaseTableHeaderFooterView

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) XYEdgeInsetsButton *selectTeamBtn;
@property (copy, nonatomic) void (^teamBtnClickBlock)(void);
@property (nonatomic,strong) TeamDeptDTO *model;
+ (CGFloat)getTeamHeaderHeight;
@end
