//
//  UserDetailTableCell.h
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeamUserDTO;

@interface UserDetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)setCellDataWith:(NSInteger)index user:(TeamUserDTO *)data;

@end
