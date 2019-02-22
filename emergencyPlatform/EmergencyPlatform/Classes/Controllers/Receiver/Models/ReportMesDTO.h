//
//  ReportMesDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"
#import "TeamUserDTO.h"
#import "JuReportImageModel.h"
#import "noteReportimg.h"
#import "LoginUserDTO.h"

@interface ReportMesDTO : BaseDataModel

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *reportTime;
@property (copy, nonatomic) NSString *audioSizet;
@property (copy, nonatomic) NSString *avi;
@property (strong, nonatomic) NSMutableArray<noteReportimg *> *noteReportimg;
@property (nonatomic, strong) LoginUserDTO *user;

@end
 
