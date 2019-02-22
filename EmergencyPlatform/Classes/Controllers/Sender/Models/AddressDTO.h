//
//  AddressDTO.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface AddressDTO : BaseDataModel

@property (copy, nonatomic) NSString *address;
@property (nonatomic) double lng;   //经度
@property (nonatomic) double lat;   //纬度

@end
