//
//  NoticeEventCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeEventCell.h"

@implementation NoticeEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(ReceiveMesDTO *)data {
    _name.text = data.title;
    _category.text = data.category;
    _time.text = data.createTime;
    _address.text = data.address;
    _situation.text = data.preliminary;
    _level.text = data.grade;
    _phone.text = data.telephone;
}
@end
