//
//  SearchTextView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SearchTextView.h"

@implementation SearchTextView

- (void)setupSubviews {
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self addSubview:self.downImgView];
    [self.downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

-(UIImageView *)downImgView {
    if (!_downImgView) {
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"search_down"];
    }
    return _downImgView;
}
@end
