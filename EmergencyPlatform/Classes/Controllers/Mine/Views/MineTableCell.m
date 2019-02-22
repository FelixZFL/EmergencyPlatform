//
//  MineTableCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MineTableCell.h"

@implementation MineTableCell

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
    _iconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldIcon",(long)index]];
    if (index == 0) {
        _markLbl.text = @"关联机构";
        _title.text = data.org.orgName;
    } else if (index == 1) {
        _markLbl.text = @"用户职能";
        _title.text = data.duty;
    } else if (index == 2) {
        _markLbl.text = @"用户角色";
        _title.text = data.roles[0].roleName;
    } else {
        _markLbl.text = @"电话号码";
        _title.text = data.telephone;
    }
}
@end
