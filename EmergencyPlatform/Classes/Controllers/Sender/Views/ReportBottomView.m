//
//  ReportBottomView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReportBottomView.h"

@implementation ReportBottomView
- (void)setupSubviews{
    [self addSubview:self.reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportBtn.backgroundColor = COLOR_COMMONRED;
        _reportBtn.titleLabel.font = FONT_18;
        [_reportBtn setTitle:@"上报内容" forState:UIControlStateNormal];
        [_reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _reportBtn.tag = 1;
    }
    return _reportBtn;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickBtnslBlock) {
        self.clickBtnslBlock();
    }
}
@end
