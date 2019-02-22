//
//  NoticeCheckInCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrivedDTO.h"

@interface NoticeCheckInCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;

- (void)setCellDataWith:(ArrivedDTO *)data;
@end
