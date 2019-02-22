//
//  SystemHelper.h
//  alaxiaoyou
//
//  Created by MoDeguang on 16/1/10.
//  Copyright © 2016年 MoDeguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SystemHelper : NSObject
//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope;
@end
