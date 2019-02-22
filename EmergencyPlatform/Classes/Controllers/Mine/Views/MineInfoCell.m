//
//  MineInfoCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MineInfoCell.h"

@implementation MineInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userImg.userInteractionEnabled = YES;
    self.userImg.layer.cornerRadius = 36.f;
    self.userImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(TeamUserDTO *)data {
    _name.text = data.userName;
    _IDCard.text=[NSString stringWithFormat:@"ID：%@",data.telephone];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:data.header] placeholderImage:[UIImage imageNamed:@"userIcon"]];

}
@end
