//
//  ReportMesDTO.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReportMesDTO.h"

@implementation ReportMesDTO

// 实现这个方法：告诉MJExtension框架数组里面装的是什么模型

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"noteReportimg" : @"noteReportimg",
             @"user":[LoginUserDTO class],
             };
}
@end