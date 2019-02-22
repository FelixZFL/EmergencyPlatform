//
//  NoticeCheckInCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeCheckInCell.h"

@implementation NoticeCheckInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(ArrivedDTO *)data {
    _address.text = data.address;
    _time.text = data.filedTime;
}
@end
