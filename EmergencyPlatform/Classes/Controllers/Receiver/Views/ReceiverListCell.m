//
//  ReceiverListCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReceiverListCell.h"

@implementation ReceiverListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _mesImgView.layer.masksToBounds = YES;
    _mesImgView.layer.cornerRadius = 25.0;
}
- (void)setCellDataWith:(ReceiveMesDTO *)data {
    [_mesImgView sd_setImageWithURL:[NSURL URLWithString:data.header] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _titleLbl.text = data.ename;
    _orderLbl.text = data.title;
    _briefLbl.text = data.notice;
    _timeLbl.text = data.createTime;
    NSString *signStr = @"";
    if (data.arrive == 1) {
        signStr = [NSString stringWithFormat:@"已签到"];
    } else {
        signStr = [NSString stringWithFormat:@"未签到"];
    }
    NSString *reportStr = @"";
    if (data.report == 1) {
        reportStr = @"已上报";
    } else {
        reportStr = @"未上报";
    }
    NSString *totalString = [NSString stringWithFormat:@"%@/%@",signStr,reportStr];
    _markLbl.text = totalString;
    NSRange range1 = [totalString rangeOfString:@"未签到"];
    NSRange range2 = [totalString rangeOfString:@"未上报"];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (range1.location != NSNotFound) {
        [mutableStr addAttribute:NSForegroundColorAttributeName value:COLOR_COMMONRED range:range1];
    }
    if (range2.location != NSNotFound) {
        [mutableStr addAttribute:NSForegroundColorAttributeName value:COLOR_COMMONRED range:range2];
    }
    _markLbl.attributedText = mutableStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
