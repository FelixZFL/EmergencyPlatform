//
//  memberCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamUserDTO.h"

@interface memberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *duty;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (strong, nonatomic) TeamUserDTO *user;
- (void)setCellDataWith:(TeamUserDTO *)data;
@end
