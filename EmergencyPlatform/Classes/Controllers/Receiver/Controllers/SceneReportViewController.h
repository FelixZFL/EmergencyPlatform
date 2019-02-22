//
//  SceneReportViewController.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "ReceiveMesDTO.h"

@interface SceneReportViewController : BaseViewController
@property (strong, nonatomic) ReceiveMesDTO *mesDto;
@property (nonatomic, copy) void(^reportSuccessBlock) (void);

@end
