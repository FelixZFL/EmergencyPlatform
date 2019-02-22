//
//  NoticeContentCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveMesDTO.h"

@interface NoticeContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *jiheTime;
@property (weak, nonatomic) IBOutlet UILabel *jiheAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHConstraint;
@property (weak, nonatomic) IBOutlet UIButton *ju_location;

- (void)setCellDataWith:(ReceiveMesDTO *)data;
@end
