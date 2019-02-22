//
//  UserInfoManager.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

//用户的基本信息....
@property(nonatomic,copy)NSString *userID,*token,*orgID,*userName;

/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (instancetype)shareUser;

/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (void)configInfo:(NSDictionary *)infoDic;

/**
 *
 用户退出登录的操作
 *
 */
+ (void)loginOut;

@end
