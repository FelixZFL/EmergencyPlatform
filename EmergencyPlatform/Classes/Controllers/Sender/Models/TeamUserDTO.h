//
//  TeamUserDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"
#import "RoleDTO.h"
#import "OrgTDO.h"

@interface TeamUserDTO : BaseDataModel

@property (assign, nonatomic) NSInteger Category;
@property (copy, nonatomic) NSString *works;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *deptID;
@property (copy, nonatomic) NSString *positions;
@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userCode;
@property (copy, nonatomic) NSString *orgID;
@property (copy, nonatomic) NSString *cardID;
@property (copy, nonatomic) NSString *duty;
@property (copy, nonatomic) NSString *header;
@property (copy, nonatomic) NSString *position;
@property (assign, nonatomic) NSInteger arrive;
@property (strong, nonatomic) NSArray<RoleDTO *> *roles;
@property (strong, nonatomic) OrgTDO *org;
@property (nonatomic, assign) BOOL isSelected;

@end
