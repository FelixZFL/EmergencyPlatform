//
//  NoticeTitleCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveMesDTO.h"
#import "TeamUserDTO.h"

@interface NoticeTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *centerName;

- (void)setCellDataWith:(ReceiveMesDTO *)data;
- (void)setCellUserDataWith:(TeamUserDTO *)data;
@end
 
