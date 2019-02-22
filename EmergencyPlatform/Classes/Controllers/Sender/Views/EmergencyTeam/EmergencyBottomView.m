//
//  EmergencyBottomView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "EmergencyBottomView.h"

@implementation EmergencyBottomView
- (void)setupSubviews {
    [self addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth/2.0);
    }];
    
    [self addSubview:self.mesBtn];
    [self.mesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth/2.0);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(0.5);
    }];
}

- (XYEdgeInsetsButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [XYEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        _callBtn.backgroundColor = COLOR_COMMONRED;
        _callBtn.titleLabel.font = FONT_14;
        _callBtn.tag = 0;
        [_callBtn setTitle:@"群打电话" forState:UIControlStateNormal];
        [_callBtn setTitleColor:COLOR_NAVBAR forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_callBtn setImage:[UIImage imageNamed:@"icon_servicelist_red"] forState:UIControlStateNormal];
//        [_callBtn setEdgeInsetsStyle:HYButtonEdgeInsetsStyleImageLeft];
//        [_callBtn setImageTitleSpace:5];
    }
    return _callBtn;
}
- (XYEdgeInsetsButton *)mesBtn {
    if (!_mesBtn) {
        _mesBtn = [XYEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        _mesBtn.backgroundColor = COLOR_COMMONRED;
        _mesBtn.titleLabel.font = FONT_14;
        _mesBtn.tag = 1;
        [_mesBtn setTitle:@"群发通知" forState:UIControlStateNormal];
        [_mesBtn setTitleColor:COLOR_NAVBAR forState:UIControlStateNormal];
        [_mesBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_mesBtn setImage:[UIImage imageNamed:@"icon_servicelist_red"] forState:UIControlStateNormal];
//        [_mesBtn setEdgeInsetsStyle:HYButtonEdgeInsetsStyleImageLeft];
//        [_mesBtn setImageTitleSpace:5];
    }
    return _mesBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_NAVBAR;
    }
    return _lineView;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickBtnslBlock) {
        self.clickBtnslBlock(sender.tag);
    }
}
@end
