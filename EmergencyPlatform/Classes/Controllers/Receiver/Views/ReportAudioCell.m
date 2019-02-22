//
//  ReportAudioCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/15.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReportAudioCell.h"

@implementation ReportAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAudio:(id)sender {
    if (self.addAudioBlock) {
        self.addAudioBlock();
    }
}
- (void)setCellDataWithStr:(NSString *)strPath {
    if (IsStrEmpty(strPath)) {
        _heightConstraint.constant = 0;
        _playImg.hidden = YES;
    } else {
        _heightConstraint.constant = 50;
        _playImg.hidden = NO;
    }
    [self layoutIfNeeded];
}
@end
