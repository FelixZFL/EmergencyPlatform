//
//  AudioCallViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AudioCallViewController.h"
#import "AudioReceiverCell.h"
#import "NoticeBottomView.h"
#import "AudioRecordView.h"
#import "XYAudioPlayer.h"
#import "XYSoundRecorder.h"
#import "NSData+Base64.h"

#define kBottomViewHit  kScreenWidth-60
#define kViewHit  72
@interface AudioCallViewController ()<UITableViewDataSource,UITableViewDelegate,XYAudioPlayerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) AudioRecordView *audioRecordView;
@property (strong, nonatomic) NoticeBottomView *bootomView;
@property (nonatomic, weak) NSTimer *timerOf60Second;
@end

@implementation AudioCallViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //实现播放器代理
    [XYAudioPlayer sharePlayer].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止播放器
    [[XYAudioPlayer sharePlayer] stopAudioPlayer];
    //删除近距离事件监听（语音未播完界面变化时强制删除）
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self setNavView];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.audioRecordView;
    [self.view addSubview:self.bootomView];
    
    self.bootomView.checkInBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
    self.bootomView.checkInBtn.titleLabel.font = FONT_18;
    [self.bootomView.checkInBtn setTitle:@"重录" forState:UIControlStateNormal];
    [self.bootomView.reportBtn setTitle:@"确认发送" forState:UIControlStateNormal];
    
    WeakSelf;
    self.audioRecordView.clickRecordBlock = ^(UIButton *sender) {
        //录音
        if ([sender.currentTitle isEqualToString:@"开始录音"]) {
            [weakSelf startRecordVoice];
        } else if ([sender.currentTitle isEqualToString:@"完成录音"]){
            [weakSelf confirmRecordVoice];
        }
    };
    
    self.bootomView.clickBtnslBlock = ^(NSInteger tag) {
        if (tag ==0) {
            //重录
            [weakSelf resetRecord];
        } else {
            //发送
            [weakSelf sendAudioMessage];
        }
    };
}
- (void)setNavView{
    self.navigationItem.title = @"群打电话";
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kViewHit-kNav);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NoticeBottomView *)bootomView{
    if (!_bootomView) {
        _bootomView = [[NoticeBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kViewHit-kNav, kScreenWidth, kViewHit)];
        _bootomView.backgroundColor = [UIColor whiteColor];
    }
    return _bootomView;
}
- (AudioRecordView *)audioRecordView{
    if (!_audioRecordView) {
        _audioRecordView = [[AudioRecordView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kBottomViewHit+100)];
        _audioRecordView.backgroundColor = [UIColor whiteColor];
    }
    return _audioRecordView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AudioReceiverCell";
    AudioReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    [cell setCellDataWith:self.userNameStr];
    return cell;
}
- (void)audioRecord {
    //录音期间禁用左滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        [self startRecordVoice];
    } else {
        showFadeOutText(@"使用此功能需要打开麦克风权限", 0, 1);
    }
}
#pragma mark -音频模块
/**
 *  开始录音
 */
- (void)startRecordVoice{
    //        //停止播放
    [[XYAudioPlayer sharePlayer] stopAudioPlayer];
    //        //开始录音
    [[XYSoundRecorder shareInstance] startSoundRecord];
    
    [self.audioRecordView.recordBtn setTitle:@"完成录音" forState:UIControlStateNormal];
    self.audioRecordView.tipsImg.image = [UIImage imageNamed:@"recordIng"];
    
    //开启定时器
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
    _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(audioCountTimer) userInfo:nil repeats:YES];
}
/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    int recordTime = [[XYSoundRecorder shareInstance] soundRecordTime];
    self.audioRecordView.timeLbl.text = [NSString stringWithFormat:@"%d秒",recordTime];
    self.audioRecordView.recordBtn.hidden = YES;
    
    [[XYSoundRecorder shareInstance] stopSoundRecord];
    [[XYSoundRecorder shareInstance] toMp3];
    
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
    
    self.audioRecordView.playBtn.hidden = NO;
    self.audioRecordView.secondLbl.hidden = NO;
    self.audioRecordView.secondLbl.text = [NSString stringWithFormat:@"%d秒",recordTime];
    self.audioRecordView.timeLbl.text = @"00:00";
    
    WeakSelf;
    self.audioRecordView.playRecordBlock = ^{
        //试听
        [weakSelf audioTestPlay];
    };
}
//重录
- (void)resetRecord {
    //删除音频文件
    [[XYSoundRecorder shareInstance] deleteRecord];
    
    self.audioRecordView.playBtn.hidden = YES;
    self.audioRecordView.secondLbl.hidden = YES;
    
    self.audioRecordView.recordBtn.hidden = NO;
    [self.audioRecordView.recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    self.audioRecordView.tipsImg.image = [UIImage imageNamed:@"recordNormal"];
}
//录音计时
- (void)audioCountTimer {
    int recordTime = [[XYSoundRecorder shareInstance] soundRecordTime];
    self.audioRecordView.timeLbl.text = [NSString stringWithFormat:@"%d秒",recordTime];
}
//试听播放本地资源
- (void)audioTestPlay {
    NSString *filePath = [[XYSoundRecorder shareInstance] soundFilePath];
    
    [[XYAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:-1];
}
//停止试听
- (void)stopTestPlay {
    [[XYAudioPlayer sharePlayer] stopAudioPlayer];
}
//发送语音
- (void)sendAudioMessage {
    NSString *soundFile = [[XYSoundRecorder shareInstance] soundFilePath];
//    NSData *audioData = [NSData dataWithContentsOfFile:soundFile];
    
    NSData *audioData = [[NSData alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]];
    
    if (audioData.bytes==0) {
        showFadeOutText(@"录制时间太短，请重新录制", 0, 1);
        return;
    }
    
    //根据NSData生成Base64编码的String
    NSString *base64Encode = [audioData base64EncodedStringWithOptions:0];
    NSLog(@"Encode:%@", base64Encode);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:base64Encode forKey:@"img"];
    [params setObject:@(base64Encode.length) forKey:@"length"];

    [NetWorkManager NetworkPOST:@"notice/upload" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        NSString *audioStr = result[@"resultdata"];
        
        if (self.isAudio) {
            if (self.refreshAudioPathBlock) {
                self.refreshAudioPathBlock(audioStr,soundFile);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self addNoticeAudio:audioStr];
        }
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送失败，请重试", 0, 1);
    }];
}

- (void)addNoticeAudio:(NSString *)audioStr {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@(1) forKey:@"classic"];
    [params setObject:self.paraString forKey:@"Users"];
    [params setObject:audioStr forKey:@"audio"];
    [params setObject:@"1" forKey:@"audioSize"];
    
    [NetWorkManager NetworkPOST:@"notice/addnotice" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送群通知成功", 0, 1);
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送失败，请重试", 0, 1);
    }];
}
@end
