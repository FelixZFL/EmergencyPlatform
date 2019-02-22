//
//  AudioPlayView.h
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/9/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlayView : UIView

@property (nonatomic, copy) NSString *audioUrl;

@property (nonatomic, assign) CGFloat playViewWidth;//外面设置，里面设置约束

@end
