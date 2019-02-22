//
//  AudioRecordView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"

typedef void(^ClickRecordBlock)(UIButton *sender);
typedef void(^PlayRecordBlock)();

@interface AudioRecordView : BaseView

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *timeLbl;
@property (strong, nonatomic) UIImageView *tipsImg;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIButton *recordBtn;

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UILabel *secondLbl;

@property (copy, nonatomic)ClickRecordBlock clickRecordBlock;
@property (copy, nonatomic)PlayRecordBlock playRecordBlock;

@end
