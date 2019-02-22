//
//  JuPushConfig.h
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
@class ReceiveMesViewController;
#ifdef DEBUG
#define IsProduction NO  //**不可更改
#else
/*======================发布环境禁止更改（除特殊情况）=====================*/
#define APP_API_Config 1
#define IsProduction YES  //不可更改
#endif
#define JuPush_Config [JuPushConfig sharedInstance]
@interface JuPushConfig : NSObject

+ (instancetype) sharedInstance;
@property (nonatomic,strong) NSDictionary *ju_userInfo;
@property (nonatomic,weak) ReceiveMesViewController *ju_receiveVC;

-(void)shMessageLanching:(NSDictionary *)launchOptions;
-(void)shRemoteNotification:(NSDictionary *)userInfo;


-(void)shJPushSetAlias;

-(void)shDidBecomeActive:(UIApplication *)application;
-(void)shEnterBackground:(UIApplication *)application;
//页面跳转
-(void)shHandlePushNotification:(NSDictionary *)userInfo;
@end
