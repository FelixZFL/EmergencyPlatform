//
//  NetWorkManager.h
//  AudioJackDemo7
//
//  Created by Tangwy on 14-3-5.
//  Copyright (c) 2014年 Chen Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>

//block类型
typedef void(^NetStartHander)(); // 发起请求
//typedef void(^NetSuccessHander)(AFHTTPRequestOperation *operation, id responseObject);   // 成功返回
typedef void(^NetSuccessHander)(NSDictionary *result);              // 成功返回
typedef void(^NetFailHander)(NSURLSessionTask *operation, NSError *error);   // 失败返回

typedef void(^RequestSuccess)(NSDictionary *result); //同步请求成功
typedef void(^RequestFailed)(NSURLResponse *response, NSError *error); //同步请求失败
typedef void(^FormImageData)(id<AFMultipartFormData> formData); // 格式化图片data

@interface NetWorkManager : NSObject

//社区POST网络请求函数
+ (void)NetworkPOST:(NSString *)URLString
       parameters:(id)paramete
      startHander:(NetStartHander)startHander
          success:(NetSuccessHander)successHander
           failed:(NetFailHander)failedHander;

//社区GET网络请求函数
+ (void)NetworkGET:(NSString *)URLString
      parameters:(id)paramete
     startHander:(NetStartHander)startHander
         success:(NetSuccessHander)successHander
          failed:(NetFailHander)failedHander;

//社区上传图片
+ (void)NetworkUploadImage:(NSString *)URLString
              parameters:(id)paramete
             startHander:(NetStartHander)startHander
                formData:(FormImageData)formImageData
                 success:(NetSuccessHander)successHander
                  failed:(NetFailHander)failedHander;

@end
