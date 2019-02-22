//
//  NetWorkManager.m
//  AudioJackDemo7
//
//  Created by Tangwy on 14-3-5.
//  Copyright (c) 2014年 Chen Jack. All rights reserved.
//

#import "NetWorkManager.h"
#import "SystemHelper.h"
#import "AppDelegate.h"

@implementation NetWorkManager


//社区POST网络请求函数
+ (void)NetworkPOST:(NSString *)URLString
       parameters:(id)paramete
      startHander:(NetStartHander)startHander
          success:(NetSuccessHander)successHander
           failed:(NetFailHander)failedHander{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/json",
                                                             @"text/javascript",
                                                             @"text/html",
                                                             @"text/plain",nil];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)paramete];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:AccessToken];
        [parameters setValue:accessToken forKey:@"token"];
    
        NSString *urlString = [ServerBaseURL stringByAppendingString:URLString];
        NSLog(@"\nrequest:%@\nparams:%@",urlString,parameters);
        [manager POST:urlString
           parameters:parameters
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 //
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSURLRequest *request = (NSURLRequest *)task.currentRequest;
                 NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
                 NSDictionary *result = (NSDictionary *)responseObject;
                 NSString *jsonStr = [SystemHelper dictionaryToJson:result];
                 if ([result[@"issuccess"] boolValue]) {
                     NSLog(@"\ndata:%@",result);
                     successHander(result);
                 }else{
                     [MBProgressHUD hideHUDForView:kWindow animated:YES];
                     showFadeOutText(result[@"message"], 0, 1);
                 }
                 //判断登陆是否过期
                 if ([result[@"message"] integerValue] == -200) {
                     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     [delegate setupLoginViewController];
                 }
                 [MBProgressHUD hideHUDForView:kWindow animated:YES];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideHUDForView:kWindow animated:YES];
                 NSURLRequest *request = (NSURLRequest *)task.currentRequest;
                 NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
                 NSLog(@"\nerror:%@",error);
                 failedHander(task,error);
             }];
        startHander();
}

//社区GET网络请求函数
+ (void)NetworkGET:(NSString *)URLString
      parameters:(id)paramete
     startHander:(NetStartHander)startHander
         success:(NetSuccessHander)successHander
          failed:(NetFailHander)failedHander{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)paramete];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:AccessToken];
    [parameters setValue:accessToken forKey:@"token"];

    NSString *urlString = [ServerBaseURL stringByAppendingString:URLString];
    NSLog(@"\nrequest:%@\nparams:%@",urlString,parameters);
    [manager GET:urlString
      parameters:parameters
        progress:^(NSProgress * _Nonnull uploadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSURLRequest *request = (NSURLRequest *)task.currentRequest;
            NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"result"] isEqualToString:@"success"]) {
                NSLog(@"\ndata:%@",result[@"data"]);
                successHander(result[@"data"]);
            }else{
                [MBProgressHUD hideHUDForView:kWindow animated:YES];
                NSLog(@"\ncode:%@\nerror:%@",result[@"code"],result[@"error"]);
                showFadeOutText(result[@"error"], 0, 1);
            }
            //判断登陆是否过期
            if ([result[@"message"] integerValue] == -200) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate setupLoginViewController];
            }
            [MBProgressHUD hideHUDForView:kWindow animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUDForView:kWindow animated:YES];
             NSURLRequest *request = (NSURLRequest *)task.currentRequest;
             NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
             NSLog(@"\nerror:%@",error);
             failedHander(task,error);
         }];
    startHander();
}

//社区上传图片
+ (void)NetworkUploadImage:(NSString *)URLString
              parameters:(id)paramete
             startHander:(NetStartHander)startHander
                formData:(FormImageData)formImageData
                 success:(NetSuccessHander)successHander
                  failed:(NetFailHander)failedHander{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)paramete];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:AccessToken];
    [parameters setValue:accessToken forKey:@"token"];
    
    NSString *urlString = [ServerBaseURL stringByAppendingString:URLString];
    NSLog(@"\nrequest:%@\nparams:%@",urlString,parameters);
    [manager POST:urlString
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            formImageData(formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
             //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSURLRequest *request = (NSURLRequest *)task.currentRequest;
            NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"result"] isEqualToString:@"success"]) {
                NSLog(@"\ndata:%@",result[@"data"]);
                successHander(result[@"data"]);
            }else{
                [MBProgressHUD hideHUDForView:kWindow animated:YES];
                NSLog(@"\ncode:%@\nerror:%@",result[@"code"],result[@"error"]);
                showFadeOutText(result[@"error"], 0, 1);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:kWindow animated:YES];
            NSURLRequest *request = (NSURLRequest *)task.currentRequest;
            NSLog(@"\nHeaders:%@",request.allHTTPHeaderFields);
            NSLog(@"\nerror:%@",error);
            failedHander(task,error);
        }];
    startHander();
}

@end
