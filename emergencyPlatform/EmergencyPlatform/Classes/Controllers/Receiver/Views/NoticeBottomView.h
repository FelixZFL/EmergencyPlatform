//
//  NoticeBottomView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"

//Block类型
typedef void(^ClickBtnslBlock)(NSInteger tag);
@interface NoticeBottomView : BaseView

@property (strong, nonatomic) UIButton *checkInBtn;
@property (strong, nonatomic) UIButton *reportBtn;

@property (copy, nonatomic)ClickBtnslBlock clickBtnslBlock;

@end
