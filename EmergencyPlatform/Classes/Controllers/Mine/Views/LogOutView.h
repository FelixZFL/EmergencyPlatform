//
//  LogOutView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"

//Block类型
typedef void(^ClickBtnslBlock)();
@interface LogOutView : BaseView

@property (strong, nonatomic) UIButton *logOutBtn;

@property (copy, nonatomic)ClickBtnslBlock clickBtnslBlock;
@end
