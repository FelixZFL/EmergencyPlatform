//
//  MapLocationViewController.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressDTO.h"

typedef void(^RefreshAddressBlock)(AddressDTO *address);
@interface MapLocationViewController : BaseViewController

@property (copy, nonatomic) RefreshAddressBlock refreshAddressBlock;
@property (nonatomic,assign)CLLocationCoordinate2D ju_location2D;
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic,copy)NSString *ju_collectTitle;
@property (strong, nonatomic) UIImageView *locationMap;
@end
