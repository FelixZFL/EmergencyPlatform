//
//  NoticeTitleCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeTitleCell.h"

@implementation NoticeTitleCell

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
    _notice.text = data.title;
    _time.text = data.createTime;
    _centerName.text = @"";
}
- (void)setCellUserDataWith:(TeamUserDTO *)data {
    _notice.text = [NSString stringWithFormat:@"%@%@%@",data.userName,data.org.orgName,data.duty];
    _time.text = @"";
}
@end
