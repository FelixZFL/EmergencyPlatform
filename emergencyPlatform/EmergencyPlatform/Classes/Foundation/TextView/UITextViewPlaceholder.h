//
//  UITextViewPlaceholder.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewPlaceholder : UITextView

/** 占位文字 */
@property (copy, nonatomic) NSString *placeholder;
/** 占位文字颜色 */
@property (strong, nonatomic) UIColor *placeholderColor;

@end
