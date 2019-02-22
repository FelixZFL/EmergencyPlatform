//
//  DatePickerView.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/9/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView()

@property (nonatomic, strong) UIDatePicker *picker;

@end


@implementation DatePickerView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - ui
- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
    saveBtn.titleLabel.font = FONT_14;
    [saveBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(0, 0, 44, 44);
    cancelBtn.titleLabel.font = FONT_14;
    [cancelBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame = CGRectMake(60, 0, kScreenWidth - 120, 44);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = COLOR_TEXT_BLACK;
    titleLbl.text = @"请选择时间";
    [self addSubview:titleLbl];
    
    
    [self addSubview:self.picker];
    self.picker.frame = CGRectMake(0, 44, kScreenWidth, 216);
}

#pragma mark - public
- (void)setType:(DatePickerViewType)type {
    _type = type;
    [self resetDateForPicker];
}

#pragma mark - action

- (void)saveBtnClick {
    
    NSLog(@"picker.date = %@",[self getTimeStringWithDate:self.picker.date]);
    NSLog(@"[NSDate date] = %@",[self getTimeStringWithDate:[NSDate date]]);

    
    if (self.type == DatePickerViewType_cannotChooseAgo && [self.picker.date compare:[NSDate date]] == NSOrderedAscending) {// 不能选过去时间  升序
        NSLog(@"升序");
        showFadeOutText(@"不能选过去时间", 0, 1);
        [self resetDateForPicker];
        return;
    }else if (self.type == DatePickerViewType_cannotChooseFuture && [self.picker.date compare:[NSDate date]] == NSOrderedDescending) {//不能选未来时间 降序
        NSLog(@"降序");
        showFadeOutText(@"不能选未来时间", 0, 1);
        [self resetDateForPicker];
        return;
    }
    
    if (self.choosedBlock) {
        self.choosedBlock([self getTimeStringWithDate:self.picker.date]);
    }
    [self removeFromSuperview];
}

- (void)cancelBtnClick {
    [self removeFromSuperview];
}

#pragma mark - private

- (void)resetDateForPicker {
    [self.picker setDate:[NSDate date] animated:YES];
}

- (NSString *)getTimeStringWithDate:(NSDate *)date {
    
    NSString *time = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    time = [formatter stringFromDate:date];
    return time;
}

#pragma mark - getter

- (UIDatePicker *)picker {
    if (!_picker) {
        _picker = [[UIDatePicker alloc] init];
        _picker.minuteInterval = 5;
    }
    return _picker;
}

@end
