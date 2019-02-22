//
//  XYSoundRecorder.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XYSoundRecorder.h"
#import "lame.h"

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface XYSoundRecorder()

@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation XYSoundRecorder

+ (XYSoundRecorder *)shareInstance {
    static XYSoundRecorder *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[XYSoundRecorder alloc] init];
        }
    });
    return sharedInstance;
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)getRecordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

#pragma mark - Public Methods

- (void)startSoundRecord {
    //    self.recordPath = [self getRecordPath];
    [self startRecord];
}

- (void)stopSoundRecord {
    NSString *str = [NSString stringWithFormat:@"%f",_recorder.currentTime];
    
    int times = [str intValue];
    if (self.recorder) {
        [self.recorder stop];
    }
    if (times >= 1) {
        if (_delegate&&[_delegate respondsToSelector:@selector(didStopSoundRecord)]) {
            [_delegate didStopSoundRecord];
        }
    } else {
        [self deleteRecord];
        [self.recorder stop];
        if ([_delegate respondsToSelector:@selector(showSoundRecordFailed)]) {
            [_delegate showSoundRecordFailed];
        }
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    //恢复外部正在播放的音乐
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
    
}

- (void)soundRecordFailed:(UIView *)view {
    [self.recorder stop];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    //恢复外部正在播放的音乐
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}

- (void)showCountdown:(int)countDown{
    //    _textLable.text = [NSString stringWithFormat:@"还可以说%d秒",countDown];
}

- (NSTimeInterval)soundRecordTime {
    return _recorder.currentTime;
}

- (void)startRecord {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    //设置AVAudioSession
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err) {
        [self soundRecordFailed:nil];
        return;
    }
    
    //设置录音输入源
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
    if(!success)
    {
        NSLog(@"error doing outputaudioportoverride - %@", [err localizedDescription]);
    }
    
    [audioSession setActive:YES error:&err];
    if(err) {
        [self soundRecordFailed:nil];
        return;
    }
    //设置文件保存路径和名称
    //    NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.caf", [[NSDate date] timeIntervalSince1970] ];
    NSString *fileName = @"/temporary.dat";
    self.recordPath = [[self getRecordPath] stringByAppendingPathComponent:fileName];
    NSURL *recordedFile = [NSURL fileURLWithPath:self.recordPath];
    
    NSURL * pathU = nil;
#if TARGET_IPHONE_SIMULATOR
    pathU = [NSURL fileURLWithPath:self.recordPath isDirectory:NO];
#else
    pathU = [NSURL URLWithString:self.recordPath];
#endif
    
    NSDictionary *dic = [self recordingSettings];
    //初始化AVAudioRecorder
    err = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:dic error:&err];
    if(_recorder == nil) {
        [self soundRecordFailed:nil];
        return;
    }
    //准备和开始录音
    [_recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    [_recorder recordForDuration:0];
}

- (void)deleteRecord {
    if (self.recorder) {
        [self.recorder stop];
        self.recordPath = @"";
        [self.recorder deleteRecording];
    }
    
}

#pragma mark - Getters

- (NSDictionary *)recordingSettings
{
    //    NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
    //    [recordSetting setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    //    //2 采样率
    //    [recordSetting setObject:[NSNumber numberWithFloat:8000] forKey: AVSampleRateKey];
    //    //3 通道的数目
    //    [recordSetting setObject:[NSNumber numberWithInt:2]forKey:AVNumberOfChannelsKey];
    //    //4 采样位数  默认 16
    //    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //    return recordSetting;
    NSMutableDictionary *recSet = [[NSMutableDictionary alloc] init];
    [recSet setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recSet setValue :[NSNumber numberWithFloat:8000.f] forKey: AVSampleRateKey];//44100.0
    [recSet setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //[recSet setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    [recSet setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return recSet;
}

- (NSString *)soundFilePath {
    return self.recordPath;
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self toMp3];
}
- (void)toMp3
{
    // 录音文件路径
    NSString *cafFilePath = self.recordPath;
    // mp3文件名
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    // mp3保存路径
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    NSLog(@"mp3FilePath ---- %@", mp3FilePath);
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        //        lame_set_in_samplerate(lame, 11025.0);
        lame_set_in_samplerate(lame, 8000.f);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        // 转换完成 输出大小
        NSInteger fileSize =  [self getFileSize:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", DocumentPath]];
        NSLog(@"RecordedFile ------- %@", [NSString stringWithFormat:@"%ld kb", fileSize/1024]);
    }
}
- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}
@end
