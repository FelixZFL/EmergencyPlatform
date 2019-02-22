//
//  ReceiveMesDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"
#import "ArrivedDTO.h"

@interface ReceiveMesDTO : BaseDataModel
@property (copy, nonatomic) NSString *noticeID;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *lng;
@property (copy, nonatomic) NSString *aggregateaddress;
@property (copy, nonatomic) NSString *aggregateLat;
@property (copy, nonatomic) NSString *aggregateLng;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *ename;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *notice;
@property (copy, nonatomic) NSString *generatedTime;
@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *preliminary;
@property (copy, nonatomic) NSString *grade;
@property (copy, nonatomic) NSString *audio;
@property (assign, nonatomic) NSInteger classic;
@property (assign, nonatomic) NSInteger arrive;
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger report;
@property (strong, nonatomic) ArrivedDTO *arrived;
@property (copy, nonatomic) NSString *orgName;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *duty;
@property (copy, nonatomic) NSString *header;

@end
