//
//  ReceiverAudioCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReceiverAudioCell.h"

@implementation ReceiverAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _mesImg.layer.masksToBounds = YES;
    _mesImg.layer.cornerRadius = 25.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(ReceiveMesDTO *)data {
    [_mesImg sd_setImageWithURL:[NSURL URLWithString:data.header] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _title.text  = [NSString stringWithFormat:@"%@(%@%@)",data.userName,data.orgName,data.duty];;
    _name.text = data.title;
    _time.text = data.createTime;
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
    _mark.text = totalString;
    NSRange range1 = [totalString rangeOfString:@"未签到"];
    NSRange range2 = [totalString rangeOfString:@"未上报"];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (range1.location != NSNotFound) {
        [mutableStr addAttribute:NSForegroundColorAttributeName value:COLOR_COMMONRED range:range1];
    }
    if (range2.location != NSNotFound) {
        [mutableStr addAttribute:NSForegroundColorAttributeName value:COLOR_COMMONRED range:range2];
    }
    _mark.attributedText = mutableStr;
}
@end
