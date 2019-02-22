//
//  SendMesAudioCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SendMesAudioCell.h"

@implementation SendMesAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setCellDataWith:(ReceiveMesDTO *)data {
    _titleLbl.text = data.ename;
    _orderLbl.text = data.title;
    _timeLbl.text = data.createTime;
    _markLbl.text = [NSString stringWithFormat:@"签到状态：%d/%d",(int)data.arrive,(int)data.total];
    /* NSString *signStr = @"";
     if (data.arrive == 1) {
     signStr = [NSString stringWithFormat:@"已签到"];
     } else {
     signStr = [NSString stringWithFormat:@"未签到"];
     }
     _markLbl.text = [NSString stringWithFormat:@"%@",signStr];*/
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
