//
//  AudioRecordView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AudioRecordView.h"

@implementation AudioRecordView
- (void)setupSubviews {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(kScreenWidth-60);
    }];
    
    [self.bgView addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(28);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.width.equalTo(self.bgView.mas_width);
    }];
    
    [self.bgView addSubview:self.tipsImg];
    [self.tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLbl.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(80);
    }];
    
    [self.bgView addSubview:self.redView];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.height.mas_equalTo(62);
    }];
    
    [self.redView addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redView.mas_centerX);
        make.centerY.equalTo(self.redView.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(33);
    }];
    
    [self.bgView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(5);
        make.left.equalTo(self.bgView.mas_left).offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-5);
        make.height.mas_equalTo(kScreenWidth-60-67);
    }];
    
    [self.redView addSubview:self.secondLbl];
    [self.secondLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.redView);
    }];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.borderWidth = 2;
        _bgView.layer.borderColor = COLOR_COMMONRED.CGColor;
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}
- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = FONT_20;
        _timeLbl.textColor = COLOR_COMMONGRAY;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.text = @"00:00";
    }
    return _timeLbl;
}
- (UIImageView *)tipsImg {
    if (!_tipsImg) {
        _tipsImg = [[UIImageView alloc] init];
        _tipsImg.image = [UIImage imageNamed:@"recordNormal"];
    }
    return _tipsImg;
}
- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = COLOR_COMMONRED;
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.backgroundColor = [UIColor clearColor];
        _recordBtn.titleLabel.font = FONT_17;
        _recordBtn.layer.cornerRadius = 10;
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.borderWidth = 2.0;
        _recordBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.tag = 0;
    }
    return _recordBtn;
}
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = [UIColor whiteColor];
        _playBtn.hidden = YES;
        [_playBtn setImage:[UIImage imageNamed:@"platyIcon"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UILabel *)secondLbl {
    if (!_secondLbl) {
        _secondLbl = [[UILabel alloc] init];
        _secondLbl.font = FONT_20;
        _secondLbl.textColor = COLOR_COMMONGRAY;
        _secondLbl.textAlignment = NSTextAlignmentCenter;
        _secondLbl.hidden = YES;
    }
    return _secondLbl;
}
- (void)clickAction:(UIButton *)sender{
    if (self.clickRecordBlock) {
        self.clickRecordBlock(sender);
    }
}
- (void)playAction:(UIButton *)sender{
    if (self.playRecordBlock) {
        self.playRecordBlock();
    }
}
@end
