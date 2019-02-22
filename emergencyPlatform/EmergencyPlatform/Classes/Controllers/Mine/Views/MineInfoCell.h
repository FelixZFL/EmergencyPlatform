//
//  MineInfoCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamUserDTO.h"

@interface MineInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *IDCard;

- (void)setCellDataWith:(TeamUserDTO *)data;
@end
