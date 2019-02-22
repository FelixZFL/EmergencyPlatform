//
//  AudioPlayView.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/9/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AudioPlayView.h"

#import "XYAudioPlayer.h"

@interface AudioPlayView()<XYAudioPlayerDelegate>

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *playTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIView *progressBgView;
@property (nonatomic, strong) UIView *progressView;
//@property (nonatomic, strong) UIView *dotView;

@property (nonatomic, assign) NSInteger playTotalTime;//总时间
@property (nonatomic, assign) NSInteger playCurrentTime;//当前播放时间

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat progressBgWidth;

@end

@implementation AudioPlayView

#pragma mark - lifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}



#pragma mark - UI

- (void)setupUI {
    
    self.playViewWidth = kScreenWidth - 20;
    self.progressBgWidth = self.playViewWidth - 10 - 42 - 10 - 50 - 10 - 50;
    
    [self setborderColor:COLOR_COMMONRED borderWidth:2];
    [self setCorner:10.f];
    
    __weak __typeof(self)weakSelf = self;
    
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.equalTo(weakSelf);
    }];
    
    [self addSubview:self.playTimeLabel];
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.playBtn.mas_right).with.mas_offset(10);
        make.width.mas_equalTo(50);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(50);
        make.centerY.equalTo(weakSelf);
    }];
    
    
    UIView *progressBgView = [[UIView alloc] init];
    progressBgView.backgroundColor = COLOR_COMMONGRAY;
    [self addSubview:progressBgView];
    [progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.playTimeLabel.mas_right);
        make.width.mas_equalTo(weakSelf.progressBgWidth);
        make.centerY.equalTo(weakSelf);
        make.height.mas_equalTo(10);
    }];
    self.progressBgView = progressBgView;
    
    
    UIView *progressView = [[UIView alloc] init];
    progressView.backgroundColor = COLOR_COMMONRED;
    
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(progressBgView);
        make.width.mas_equalTo(0);
    }];
    self.progressView = progressView;
    
    UIView *dotView = [[UIView alloc] init];
    dotView.backgroundColor = [UIColor whiteColor];
    [dotView setLayerShadowOffset:CGSizeZero opacity:0.3 color:[UIColor blackColor] radius:3 cornerRadius:6];
    [self addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(progressView.mas_right);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(progressView);
    }];
}

#pragma mark - public
- (void)setPlayViewWidth:(CGFloat)playViewWidth {
    _playViewWidth = playViewWidth;
    
    _progressBgWidth = playViewWidth - 10 - 42 - 10 - 50 - 10 - 50;
}

- (void)setAudioUrl:(NSString *)audioUrl {
    if ([_audioUrl isEqualToString:audioUrl]) {
        return;
    }
    _audioUrl = audioUrl;
    
    [self getAudioTotalTimeInfo];
}

#pragma mark - action

- (void)playBtnClickAction:(UIButton *)sender {
    if (!self.audioUrl) {
        return;
    }
    [XYAudioPlayer sharePlayer].delegate = self;
    [[XYAudioPlayer sharePlayer] playAudioWithURLString:self.audioUrl atIndex:1];
}

#pragma mark - private

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getAudioTotalTimeInfo {
    __weak __typeof(self)weakSelf = self;
    [[XYAudioPlayer sharePlayer] getAudioInfoWithURLString:self.audioUrl atIndex:1 audioInfo:^(double playTotalTime, double playCurrentTime) {
        NSLog(@"getAudioTotalTimeInfo--- tt---%f, ct ----- %f",playTotalTime,playCurrentTime);
        NSInteger totalTime = ceil(playTotalTime);
        NSInteger minites = totalTime/60;
        NSInteger seconds = totalTime%60;
        weakSelf.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minites,seconds];
        
        NSInteger currentTime = ceil(playCurrentTime);
        minites = currentTime/60;
        seconds = currentTime%60;
        weakSelf.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minites,seconds];
        
        weakSelf.playTotalTime = totalTime;
        weakSelf.playCurrentTime = currentTime;
        
        
        CGFloat multiplied = 0;
        if (totalTime != 0) {
            multiplied = currentTime/(float)totalTime;
        }
        NSLog(@"multiplied---%f",multiplied);

        [weakSelf.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.progressBgWidth * multiplied);
        }];
        
        [weakSelf layoutIfNeeded];
    }];
    
}

- (void)updateAudioTimeInfo {
    
    double playTotalTime = [[XYAudioPlayer sharePlayer] juPlayTotalTime];
    double playCurrentTime = [[XYAudioPlayer sharePlayer] juPlayCurrentTime];
    NSLog(@"updateAudioTimeInfo --- tt---%f, ct ----- %f",playTotalTime,playCurrentTime);
    NSInteger totalTime = ceil(playTotalTime);
    NSInteger minites = totalTime/60;
    NSInteger seconds = totalTime%60;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minites,seconds];
    
    NSInteger currentTime = ceil(playCurrentTime);
    minites = currentTime/60;
    seconds = currentTime%60;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minites,seconds];
    
    self.playTotalTime = totalTime;
    self.playCurrentTime = currentTime;
    
    CGFloat multiplied = 0;
    if (totalTime != 0) {
        multiplied = currentTime/(float)totalTime;
    }
    NSLog(@"multiplied---%f",multiplied);
    __weak __typeof(self)weakSelf = self;
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.progressBgWidth * multiplied);
    }];

    [self layoutIfNeeded];
}




#pragma mark - XYAudioPlayerDelegate
///播放状态改变
- (void)audioPlayerStateDidChanged:(XYAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    if (audioPlayerState == XYAudioPlayerStateCancel || XYAudioPlayerStateNormal) {
        NSLog(@" audioPlayerStateDidChanged  XYAudioPlayerStateCancel XYAudioPlayerStateNormal ");
        [self stopTimer];
        [self getAudioTotalTimeInfo];
        [self.playBtn setImage:[UIImage imageNamed:@"platyIcon"] forState:UIControlStateNormal];
    }else if (audioPlayerState == XYAudioPlayerStatePlaying) {
        NSLog(@" audioPlayerStateDidChanged  XYAudioPlayerStatePlaying");

        [self.playBtn setImage:[UIImage imageNamed:@"playStopIcon"] forState:UIControlStateNormal];
        
        [self stopTimer];
        
        self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(updateAudioTimeInfo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];//playStopIcon
        [_playBtn setImage:[UIImage imageNamed:@"platyIcon"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)playTimeLabel {
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.font = FONT_13;
        _playTimeLabel.textColor = COLOR_TEXT_LIGHTGRAY;
        _playTimeLabel.textAlignment = NSTextAlignmentLeft;
        _playTimeLabel.text = @"00:00";
    }
    return _playTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = FONT_13;
        _totalTimeLabel.textColor = COLOR_TEXT_LIGHTGRAY;
        _totalTimeLabel.textAlignment = NSTextAlignmentRight;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}


@end
