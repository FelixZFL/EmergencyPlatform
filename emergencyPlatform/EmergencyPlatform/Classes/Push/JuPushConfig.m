//
//  JuPushConfig.m
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JuPushConfig.h"
#import "JuPushService.h"
#import "ReceiveMesViewController.h"
@interface JuPushConfig()

@end



@implementation JuPushConfig

+ (instancetype) sharedInstance
{
    static JuPushConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}
-(void)shMessageLanching:(NSDictionary *)launchOptions{

    [self shJPushSet];
    
    if (IsProduction) {
        [JuPushService setLogOFF];
    }
    [JuPushService setupWithOption:launchOptions appKey:@"e98470d3ffd249e401c2bf5f" channel:@"Publish channel" apsForProduction:IsProduction];
    /**设置别名和tag*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shJPushSetAlias];
    });
    self.ju_userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

}
-(void)shJPushSetAlias{
    NSString *userID=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:UserID] ];
    if (userID.length==0) {
        return;
    }
    NSString *alias=[NSString stringWithFormat:@"emergency_%@",userID];
    [JuPushService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
}

-(void)shRemoteNotification:(NSDictionary *)userInfo{
 
    if(!userInfo)return;

    [JuPushService handleRemoteNotification:userInfo];
    if ([UIApplication sharedApplication].applicationState!=UIApplicationStateActive) {//已启动不在前台点消息进入
        if (![UIApplication sharedApplication].idleTimerDisabled) {
            [self shHandlePushNotification:userInfo];
        }
    }
    else{///消息推送时应用在前台
        [self shHandlePushNotification:userInfo];
    }
}
-(void)shEnterBackground:(UIApplication *)application{
    
}
-(void)shDidBecomeActive:(UIApplication *)application{
    
    if (self.ju_userInfo) {///< 首次启动消息推送
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shHandlePushNotification:self.ju_userInfo];
        });
    }
}

//页面跳转
-(void)shHandlePushNotification:(NSDictionary *)userInfo{
    if (!userInfo) return;
   
    @synchronized (self) {
        if (_ju_receiveVC) {
            _ju_receiveVC.tabBarController.selectedIndex=0;
            [_ju_receiveVC shRefreshData];
            self.ju_userInfo=nil;
        }
    }
}
//极光推送
-(void)shJPushSet{
    /* 启动显示推送内容*/
    if(([[[UIDevice currentDevice]systemVersion] floatValue])>10){
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"授权成功");
                }
            }];
             [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [JuPushService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                               UIUserNotificationTypeSound |
                                                               UIUserNotificationTypeAlert)
                                                   categories:nil];
        }
        
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){ //应用在前台收到通知
    [self shRemoteNotification:notification.request.content.userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){ //点击通知进入应用
    [self shRemoteNotification:response.notification.request.content.userInfo];
}

@end
