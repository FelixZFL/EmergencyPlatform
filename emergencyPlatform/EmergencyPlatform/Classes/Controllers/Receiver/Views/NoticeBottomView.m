//
//  NoticeBottomView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeBottomView.h"

#define kWidthBtn (kScreenWidth-60)/2.0
@implementation NoticeBottomView
- (void)setupSubviews{
    [self addSubview:self.checkInBtn];
    [self.checkInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(kWidthBtn);
    }];
    
    [self addSubview:self.reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkInBtn.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(kWidthBtn);
    }];
}
- (UIButton *)checkInBtn{
    if (!_checkInBtn) {
        _checkInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkInBtn.backgroundColor = COLOR_COMMONRED;
        _checkInBtn.titleLabel.font = FONT_18;
        [_checkInBtn setTitle:@"到达签到" forState:UIControlStateNormal];
        [_checkInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkInBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkInBtn.layer.cornerRadius = 5.0;
        _checkInBtn.tag = 0;
    }
    return _checkInBtn;
}
- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportBtn.backgroundColor = COLOR_COMMONRED;
        _reportBtn.titleLabel.font = FONT_18;
        [_reportBtn setTitle:@"上报内容" forState:UIControlStateNormal];
        [_reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _reportBtn.layer.cornerRadius = 5.0;
        _reportBtn.tag = 1;
    }
    return _reportBtn;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickBtnslBlock) {
        self.clickBtnslBlock(sender.tag);
    }
}
@end
