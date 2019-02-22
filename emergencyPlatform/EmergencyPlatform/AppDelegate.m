//
//  AppDelegate.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import<BaiduMapAPI_Base/BMKBaseComponent.h>
#import<BaiduMapAPI_Base/BMKMapManager.h>
#import "LoginsViewController.h"
#import "MainViewController.h"
#import "JuPushConfig.h"
#import "JuPushService.h"

@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    _mapManager = [[BMKMapManager alloc]init];
//    lBrvFEkvsrLsfY9h4frqzDXNl4ed3xdG
    //1uL078CrgaDhYpz5pO5Fvz819wMdKOf5
//    iWZrZdmW576WvEK13eUCMaGKLVoKpt4X 自己
    BOOL ret = [_mapManager start:@"iWZrZdmW576WvEK13eUCMaGKLVoKpt4X" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UserID];
    if (userId) {
        [self setupMainViweController];
    }else {
        [self setupLoginViewController];
    }
    
    
      [[JuPushConfig sharedInstance] shMessageLanching:launchOptions];///< 推送设置
    
    return YES;
}

//进入登录页面
- (void)setupLoginViewController
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    LoginsViewController *loginController = [[LoginsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}

- (void)setupMainViweController  {
    //跳主页
    MainViewController *mainTab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = mainTab;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        [JuPushService registerDeviceToken:deviceToken];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JuPush_Config shDidBecomeActive:application];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JuPush_Config shRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JuPush_Config shRemoteNotification:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
