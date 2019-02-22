//
//  ArrivedDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface ArrivedDTO : BaseDataModel

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *deptID;
@property (copy, nonatomic) NSString *filedTime;
@property (assign, nonatomic) NSInteger isDelete;
@property (copy, nonatomic) NSString *noticeDeptID;
@property (copy, nonatomic) NSString *noticeID;
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *works;

@end
