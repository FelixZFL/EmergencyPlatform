//
//  EmergencyBottomView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"
#import "XYEdgeInsetsButton.h"

//Block类型
typedef void(^ClickBtnslBlock)(NSInteger tag);
@interface EmergencyBottomView : BaseView

@property (strong, nonatomic) XYEdgeInsetsButton *callBtn;
@property (strong, nonatomic) XYEdgeInsetsButton *mesBtn;
@property (strong, nonatomic) UIView *lineView;

@property (copy, nonatomic)ClickBtnslBlock clickBtnslBlock;
@end
