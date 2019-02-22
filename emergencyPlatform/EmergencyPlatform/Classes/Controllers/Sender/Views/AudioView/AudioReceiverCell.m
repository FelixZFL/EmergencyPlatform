//
//  AudioReceiverCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AudioReceiverCell.h"

@implementation AudioReceiverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWith:(NSString *)data {
    _receiverName.text = data;
    
    //修复高度
    CGSize size = [_receiverName sizeThatFits:CGSizeMake(kScreenWidth-40, MAXFLOAT)];
    if (size.height <= 15) {
        _heightNameConstraint.constant = 15;
    } else {
        _heightNameConstraint.constant = size.height;
    }
    [self layoutIfNeeded];
}
@end
