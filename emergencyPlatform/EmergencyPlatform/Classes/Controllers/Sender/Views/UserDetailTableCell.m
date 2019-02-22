//
//  UserDetailTableCell.m
//  EmergencyPlatform
//
//  Created by zfl－mac on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserDetailTableCell.h"
#import "TeamUserDTO.h"

@implementation UserDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellDataWith:(NSInteger)index user:(TeamUserDTO *)data {
    _lineView.hidden = NO;
    if (index == 0) {
        _titleLabel.text = @"单位";
        _contentLabel.text = data.org.orgName;
    } else if (index == 1) {
        _titleLabel.text = @"用户职务";
        _contentLabel.text = data.roles[0].roleName;
    } else if (index == 2) {
        _titleLabel.text = @"职称";
        _contentLabel.text = data.duty;
    } else {
        _titleLabel.text = @"电话号码";
        _contentLabel.text = data.telephone;
        _lineView.hidden = YES;
    }
}

@end
