//
//  NSObject+additions.h
//  alaxiaoyou
//
//  Created by mac on 2018/1/29.
//  Copyright © 2018年 MoDeguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (additions)
/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
@end
