//
//  LogOutView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LogOutView.h"

@implementation LogOutView

- (void)setupSubviews{
    [self addSubview:self.logOutBtn];
    [self.logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(60);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}
- (UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.backgroundColor = COLOR_COMMONRED;
        _logOutBtn.titleLabel.font = FONT_18;
        [_logOutBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _logOutBtn.layer.cornerRadius = 5.0;
        _logOutBtn.tag = 1;
    }
    return _logOutBtn;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickBtnslBlock) {
        self.clickBtnslBlock();
    }
}

@end
