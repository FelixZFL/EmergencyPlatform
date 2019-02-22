//
//  NoticeContentCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeContentCell.h"

@implementation NoticeContentCell

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
    _contentLbl.text = data.notice;
    
    _jiheTime.text = data.generatedTime;
    _jiheAddress.text = data.aggregateaddress;
    //修复高度
    CGSize size = [_contentLbl sizeThatFits:CGSizeMake(kScreenWidth-92, MAXFLOAT)];
    if (size.height <= 14) {
        _contentHConstraint.constant = 14;
    } else {
        _contentHConstraint.constant = size.height;
    }
    [self layoutIfNeeded];
}
@end
