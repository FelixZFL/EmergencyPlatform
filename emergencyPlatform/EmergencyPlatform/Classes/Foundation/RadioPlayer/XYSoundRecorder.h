//
//  XYSoundRecorder.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol XYSoundRecorderDelegate <NSObject>

- (void)showSoundRecordFailed;
- (void)didStopSoundRecord;

@end

@interface XYSoundRecorder : NSObject

@property (nonatomic, copy) NSString *soundFilePath;
@property (nonatomic, weak) id<XYSoundRecorderDelegate>delegate;

+ (XYSoundRecorder *)shareInstance;
/**
 *  开始录音
 *
 *  @param view 展现录音指示框的父视图
 *  @param path 音频文件保存路径
 */
- (void)startSoundRecord;
/**
 *  录音结束
 */
- (void)stopSoundRecord;
/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)soundRecordFailed:(UIView *)view;

/**
 *  最后10秒，显示你还可以说X秒
 *
 *  @param countDown X秒
 */
- (void)showCountdown:(int)countDown;
/**
 *  删除录音
 */
- (void)deleteRecord;

- (void)toMp3;

- (NSTimeInterval)soundRecordTime;

@end

