//
//  XYCategoryMenu.h
//  alaxiaoyou
//
//  Created by mac on 17/3/7.
//  Copyright © 2017年 MoDeguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMenuItem.h"

// Menu将要显示的通知
extern NSString * const XYCategoryMenuWillAppearNotification;
// Menu已经显示的通知
extern NSString * const XYCategoryMenuDidAppearNotification;
// Menu将要隐藏的通知
extern NSString * const XYCategoryMenuWillDisappearNotification;
// Menu已经隐藏的通知
extern NSString * const XYCategoryMenuDidDisappearNotification;


typedef void(^XYCategoryMenuSelectedItem)(NSInteger index, XYMenuItem *item);

typedef enum {
    XYCategoryMenuBackgrounColorEffectSolid      = 0, //!<背景显示效果.纯色
    XYCategoryMenuBackgrounColorEffectGradient   = 1, //!<背景显示效果.渐变叠加
} XYCategoryMenuBackgrounColorEffect;

@interface XYCategoryMenu : NSObject
+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(XYCategoryMenuSelectedItem)selectedItem;

+ (void)dismissMenu;
+ (BOOL)isShow;

// 主题色
+ (UIColor *)tintColor;
+ (void)setTintColor:(UIColor *)tintColor;

// 圆角
+ (CGFloat)cornerRadius;
+ (void)setCornerRadius:(CGFloat)cornerRadius;

// 箭头尺寸
+ (CGFloat)arrowSize;
+ (void)setArrowSize:(CGFloat)arrowSize;

// 标题字体
+ (UIFont *)titleFont;
+ (void)setTitleFont:(UIFont *)titleFont;

// 背景效果
+ (XYCategoryMenuBackgrounColorEffect)backgrounColorEffect;
+ (void)setBackgrounColorEffect:(XYCategoryMenuBackgrounColorEffect)effect;

// 是否显示阴影
+ (BOOL)hasShadow;
+ (void)setHasShadow:(BOOL)flag;

// 选中颜色
+ (UIColor*)selectedColor;
+ (void)setSelectedColor:(UIColor*)selectedColor;

// 分割线颜色
+ (UIColor*)separatorColor;
+ (void)setSeparatorColor:(UIColor*)separatorColor;

/// 菜单元素垂直方向上的边距值
+ (CGFloat)menuItemMarginY;
+ (void)setMenuItemMarginY:(CGFloat)menuItemMarginY;

@end
