//
//  XYAudioPlayer.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XYAudioPlayerState){
    XYAudioPlayerStateNormal = 0,/**< 未播放状态 */
    XYAudioPlayerStatePlaying = 2,/**< 正在播放 */
    XYAudioPlayerStateCancel = 3,/**< 播放被取消 */
};

@protocol XYAudioPlayerDelegate <NSObject>

- (void)audioPlayerStateDidChanged:(XYAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index;

@end

@interface XYAudioPlayer : NSObject

@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) id<XYAudioPlayerDelegate>delegate;

+ (instancetype)sharePlayer;

/**
 * 播放音频
 index -1 表示本地文件
 **/
- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index;
/**
 * 获取音频信息
 index -1 表示本地文件
 **/
- (void)getAudioInfoWithURLString:(NSString *)URLString atIndex:(NSUInteger)index audioInfo:(void (^)(double playTotalTime, double playCurrentTime))audioInfo;

- (void)stopAudioPlayer;
- (void)setAudioPlayerState:(XYAudioPlayerState)audioPlayerState;
-(double)juPlayTotalTime;
-(double)juPlayCurrentTime;
@end
