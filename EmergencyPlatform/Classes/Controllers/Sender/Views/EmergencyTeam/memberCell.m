//
//  memberCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "memberCell.h"

@implementation memberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWith:(TeamUserDTO *)data {
    _user = data;
    _userName.text = data.userName;
    _duty.text = [NSString stringWithFormat:@"(%@/%@)",data.duty,data.works];
    _selectedBtn.selected = data.isSelected;
    
}
@end
