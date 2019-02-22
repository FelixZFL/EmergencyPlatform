//
//  OrgTDO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface OrgTDO : BaseDataModel
@property (copy, nonatomic) NSString *orgID;
@property (copy, nonatomic) NSString *orgName;
@property (copy, nonatomic) NSString *sortName;
@end
