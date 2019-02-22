//
//  Constant.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
#define kWindow             [UIApplication sharedApplication].keyWindow
#define kDefaultUserIcon    [UIImage imageNamed:@"userIcon_default"]
#define kDefaultPhoto       [UIImage imageNamed:@"photo_default"]
#define kDefaultBanner      [UIImage imageNamed:@"banner_default"]
#define kDefaultLoading     [UIImage imageNamed:@"loading_default"]
#define kDefaultLoadFail    [UIImage imageNamed:@"load_fail_default"]
#define kDefaultEmptyMes    [UIImage imageNamed:@"empty_message"]

//固定高度
#define kNav            (kScreenHeight == 812.0 ? 88 : 64)
#define kStatus         20
#define kNavBar         44
#define kTabBar         49
#define kTitleWidth     200
#define kPickerHeight   216
#define kDefaultCellHit 45

//保存用户信息
#define UserInfoData  @"UserInfoData"
//保存Token
#define AccessToken  @"AccessToken"
#define UserID   @"userId"
//刷新Token
#define RefreshToken   @"RefreshToken"
//只Debug输出
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif
//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
//配置颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBAColor(rgba)    [UIColor colorWithRed:((rgba>>24)&0xff)/255.0 green:((rgba>>16)&0xff)/255.0 blue:((rgba>>8)&0xff)/255.0 alpha:(rgba&0xff)/255.0]

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//弱引用self
#define WeakSelf __weak typeof(self) weakSelf = self

//常用颜色
#define COLOR_NAVBAR            RGBAColor(0xffffffff)
//灰色透明底
#define COLOR_MARKVIEW          RGBACOLOR(0,0,0,0.5)
//浅灰色透明底
#define COLOR_LIGHTMARKVIEW     RGBACOLOR(0,0,0,0.1)

#define BACKGROUNDCOLOR         RGBAColor(0xf4f4f4ff)
#define COLOR_SEPARATE          RGBAColor(0xDDDDDDff)

#define COLOR_COMMONBLUE        RGBAColor(0x4cc7ddff)
#define COLOR_COMMONNICEBLUE    RGBAColor(0x00B8FFff)
#define COLOR_COMMONDEEPBLUE    RGBAColor(0x36BAFFff)
#define COLOR_COMMONLIGHTBLUE   RGBAColor(0x56C5FFff)

#define COLOR_COMMONGRAY        RGBAColor(0xecececff)
#define COLOR_COMMONYELLOW      RGBAColor(0xFF9000ff)
#define COLOR_COMMONLIGHTYELLOW RGBAColor(0xFFB800ff)
#define COLOR_TEXT_GOLDEN        RGBAColor(0xffe9a8ff)

#define COLOR_TEXT_BLACK        RGBAColor(0x333333ff)
#define COLOR_TEXT_GRAY         RGBAColor(0x666666ff)
#define COLOR_TEXT_LIGHTGRAY    RGBAColor(0x999999ff)
#define COLOR_TEXT_GRAY         RGBAColor(0x666666ff)
#define COLOR_TEXT_PLACEHOLDER  RGBAColor(0xccccccff)

///主题 红色
#define COLOR_COMMONRED         RGBAColor(0xf35952ff)

//常用字体大小
#define FONT_20 [UIFont systemFontOfSize:20.0f]
#define FONT_18 [UIFont systemFontOfSize:18.0f]
#define FONT_17 [UIFont systemFontOfSize:17.0f]
#define FONT_16 [UIFont systemFontOfSize:16.0f]
#define FONT_15 [UIFont systemFontOfSize:15.0f]
#define FONT_14 [UIFont systemFontOfSize:14.0f]
#define FONT_13 [UIFont systemFontOfSize:13.0f]
#define FONT_12 [UIFont systemFontOfSize:12.0f]
#define FONT_11 [UIFont systemFontOfSize:11.0f]
#define FONT_10 [UIFont systemFontOfSize:10.0f]
#define FONT_9 [UIFont systemFontOfSize:9.0f]

#define FONT_BOLD_24 [UIFont boldSystemFontOfSize:24.0f]
#define FONT_BOLD_22 [UIFont boldSystemFontOfSize:22.0f]
#define FONT_BOLD_20 [UIFont boldSystemFontOfSize:20.0f]
#define FONT_BOLD_19 [UIFont boldSystemFontOfSize:19.0f]
#define FONT_BOLD_18 [UIFont boldSystemFontOfSize:18.0f]
#define FONT_BOLD_17 [UIFont boldSystemFontOfSize:17.0f]
#define FONT_BOLD_16 [UIFont boldSystemFontOfSize:16.0f]
#define FONT_BOLD_15 [UIFont boldSystemFontOfSize:15.0f]
#define FONT_BOLD_14 [UIFont boldSystemFontOfSize:14.0f]
#define FONT_BOLD_13 [UIFont boldSystemFontOfSize:13.0f]
#define FONT_BOLD_12 [UIFont boldSystemFontOfSize:12.0f]
#define FONT_BOLD_11 [UIFont boldSystemFontOfSize:11.0f]
#define FONT_BOLD_10 [UIFont boldSystemFontOfSize:10.0f]

//沙盒中Document文件夹路径
#define CACHE_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

//----------------------视图相关---------------------------
//得到视图的right bottom的X,Y坐标点
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)

//得到视图的left top的X,Y坐标点
#define VIEW_X(view) (view.frame.origin.x)
#define VIEW_Y(view) (view.frame.origin.y)

//得到视图的尺寸:宽度、高度
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//判断IOS11版本
#define IOS11 @available(iOS 11.0, *)
//#define IOS11 ([[UIDevice currentDevice].systemVersion intValue] >= 11 ? YES : NO)
//导航栏高度
#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))
//判断iPhoneX
#define is_iPhoneX [UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f

#endif /* Constant_h */
