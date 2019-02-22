//
//  PFBPushService.h
//  PFBDoctor
//
//  Created by Juvid on 2017/6/29.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
//重新jpush方法，方便日后转平台
@interface JuPushService : NSObject

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

+ (void)registerDeviceToken:(NSData *)deviceToken;

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories;
+ (void)setLogOFF;

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction;

+ (BOOL)setBadge:(NSInteger)value;

+ (void)setTags:(NSSet *)tags
          alias:(NSString *)alias
fetchCompletionHandle:(void (^)(int iResCode, NSSet *iTags, NSString *iAlias))completionHandler;

@end
