//
//  CallPhoneView.h
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"

@interface CallPhoneView : BaseView

@property (strong, nonatomic) UIButton *callPhoneBtn;

@property (copy, nonatomic) void (^clickBtnslBlock) (void);

@end
