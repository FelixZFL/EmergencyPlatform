//
//  MineTableCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamUserDTO.h"

@interface MineTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *markLbl;
@property (weak, nonatomic) IBOutlet UILabel *title;

-(void)setCellDataWith:(NSInteger)index user:(TeamUserDTO *)data;
@end
