//
//  RoleDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface RoleDTO : BaseDataModel
@property (copy, nonatomic) NSString *roleID;
@property (copy, nonatomic) NSString *roleName;
@end
