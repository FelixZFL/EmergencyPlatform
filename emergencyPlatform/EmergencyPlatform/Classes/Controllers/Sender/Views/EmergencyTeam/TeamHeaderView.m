//
//  TeamHeaderView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TeamHeaderView.h"
#import "TeamDeptDTO.h"

@implementation TeamHeaderView
- (void)setupSubviews {
    [self addSubview:self.topView];
    
    [self.topView addSubview:self.selectTeamBtn];
    [self.selectTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(20);
        make.right.equalTo(self.topView.mas_right).offset(0);
        make.top.equalTo(self.topView.mas_top).offset(0);
        make.height.mas_equalTo(44);
    }];
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth-20, 44)];
        _topView.backgroundColor = [UIColor whiteColor];
        //画部分圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _topView.bounds;
        maskLayer.path = maskPath.CGPath;
        _topView.layer.mask = maskLayer;
    }
    return _topView;
}
- (XYEdgeInsetsButton *)selectTeamBtn {
    if (!_selectTeamBtn) {
        _selectTeamBtn = [XYEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        [_selectTeamBtn setImage:[UIImage imageNamed:@"arrow_right"]
                              forState:UIControlStateNormal];
        [_selectTeamBtn setImage:[UIImage imageNamed:@"arrow_down"]
                              forState:UIControlStateSelected];
        [_selectTeamBtn setTitleColor:COLOR_NAVBAR
                                   forState:UIControlStateNormal];
        _selectTeamBtn.titleLabel.font = FONT_BOLD_14;
        [_selectTeamBtn setEdgeInsetsStyle:HYButtonEdgeInsetsStyleImageLeft];
        _selectTeamBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selectTeamBtn addTarget:self action:@selector(teamBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectTeamBtn setImageTitleSpace:15];
    }
    return _selectTeamBtn;
}
+ (CGFloat)getTeamHeaderHeight{
    return 54;
}

-(void)setModel:(TeamDeptDTO *)model {
    _model = model;
    [self.selectTeamBtn setTitle:model.deptName forState:UIControlStateNormal];
}

- (void)teamBtnClickAction:(UIButton *)sender {
    self.model.isOpened = !self.model.isOpened;
    if (self.teamBtnClickBlock) {
        self.teamBtnClickBlock();
    }
}

@end
