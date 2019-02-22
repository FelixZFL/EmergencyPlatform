//
//  TeamDeptDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"
#import "TeamUserDTO.h"

@interface TeamDeptDTO : BaseDataModel

@property (copy, nonatomic) NSString *deptName;
@property (assign, nonatomic) NSInteger deptLevel;
@property (copy, nonatomic) NSString *sortName;
@property (assign, nonatomic) NSInteger isDelete;
@property (copy, nonatomic) NSString *deptID;
@property (copy, nonatomic) NSString *sort;
@property (copy, nonatomic) NSString *orgID;
@property (assign, nonatomic) NSInteger son;
@property (copy, nonatomic) NSString *deptPath;
@property (assign, nonatomic) NSInteger fixed;
@property (copy, nonatomic) NSString *parentdeptID;
@property (nonatomic) BOOL isAllSelect;
@property (nonatomic) BOOL isOpened;
@property (strong, nonatomic) NSMutableArray<TeamDeptDTO *> *subDept;
@property (strong, nonatomic) NSArray<TeamUserDTO *> *user;
@end
