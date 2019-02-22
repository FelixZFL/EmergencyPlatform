//
//  CallPhoneView.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CallPhoneView.h"

@implementation CallPhoneView

- (void)setupSubviews{
    [self addSubview:self.callPhoneBtn];
    [self.callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(60);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}
- (UIButton *)callPhoneBtn{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callPhoneBtn.backgroundColor = COLOR_COMMONRED;
        _callPhoneBtn.titleLabel.font = FONT_18;
        [_callPhoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_callPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_callPhoneBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _callPhoneBtn.layer.cornerRadius = 5.0;
        _callPhoneBtn.tag = 1;
    }
    return _callPhoneBtn;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickBtnslBlock) {
        self.clickBtnslBlock();
    }
}


@end
