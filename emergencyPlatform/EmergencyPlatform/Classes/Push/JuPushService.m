//
//  PFBPushService.m
//  PFBDoctor
//
//  Created by Juvid on 2017/6/29.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPushService.h"

@implementation JuPushService
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo{
    [JPUSHService handleRemoteNotification:remoteInfo];
}
+ (void)registerDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories{
    [JPUSHService registerForRemoteNotificationTypes:types categories:categories];
}
+ (void)setLogOFF{
    [JPUSHService setLogOFF];
}

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction{
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction];
}
+ (BOOL)setBadge:(NSInteger)value{
    return [JPUSHService setBadge:value];
}
+ (void)setTags:(NSSet *)tags
          alias:(NSString *)alias
fetchCompletionHandle:(void (^)(int iResCode, NSSet *iTags, NSString *iAlias))completionHandler{
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:completionHandler];
}
@end
