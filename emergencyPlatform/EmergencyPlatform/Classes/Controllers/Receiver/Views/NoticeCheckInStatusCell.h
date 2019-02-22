//
//  NoticeCheckInStatusCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamUserDTO.h"

@interface NoticeCheckInStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@property (weak, nonatomic) IBOutlet UILabel *arrive;

- (void)setCellDataWith:(TeamUserDTO *)data;
@end
