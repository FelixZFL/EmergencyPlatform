//
//  AudioCallViewController.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshAudioPathBlock)(NSString *str,NSString *ju_localUrl);
@interface AudioCallViewController : BaseViewController

@property (strong, nonatomic) NSString *userNameStr;
@property (strong, nonatomic) NSString *paraString;
@property (nonatomic) BOOL isAudio;

@property (copy, nonatomic) RefreshAudioPathBlock refreshAudioPathBlock;
@end
