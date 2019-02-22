//
//  LoginUserDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface LoginUserDTO : BaseDataModel

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *orgID;
@property (copy, nonatomic) NSString *departmentID;
@end
 
