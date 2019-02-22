//
//  NoticeCheckInStatusCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeCheckInStatusCell.h"

@implementation NoticeCheckInStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(TeamUserDTO *)data {
    _name.text = data.userName;
    _mark.text = [NSString stringWithFormat:@"(%@/%@)",data.telephone,data.duty];
    if (data.arrive == 1) {
        _arrive.text = @"已签到";
    } else {
        _arrive.text = @"未签到";
    }
}
@end
