//
//  DatePickerView.h
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/9/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DatePickerViewType_cannotChooseAgo,
    DatePickerViewType_cannotChooseFuture,
} DatePickerViewType;


@interface DatePickerView : UIView

@property (nonatomic, copy) void(^choosedBlock) (NSString *chooseTime);

@property (nonatomic, assign) DatePickerViewType type;

@end
