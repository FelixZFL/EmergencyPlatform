//
//  XYPostPhotosViewCell.m
//  alaxiaoyou
//
//  Created by Andy on 2016/11/18.
//  Copyright © 2016年 MoDeguang. All rights reserved.
//

#import "XYPostPhotosViewCell.h"

@implementation XYPostPhotosViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.photo];
        [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photo.mas_top);
            make.right.equalTo(self.photo.mas_right);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIImageView *)photo{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.backgroundColor = [UIColor clearColor];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.layer.masksToBounds = YES;
    }
    return _photo;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = [UIColor clearColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        //[_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -15)];
        [_deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)deletePhoto:(UIButton *)button{
    if (self.deletePhotoBlock) {
        self.deletePhotoBlock(button.tag);
    }
}

@end
