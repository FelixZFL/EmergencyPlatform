//
//  MapChooseAddressViewController.h
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"
@class AddressDTO;


@interface MapChooseAddressViewController : BaseViewController

@property (copy, nonatomic) void(^refreshAddressBlock)(AddressDTO *address);


@end
