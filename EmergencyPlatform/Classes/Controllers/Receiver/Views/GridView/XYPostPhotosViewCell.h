//
//  XYPostPhotosViewCell.h
//  alaxiaoyou
//
//  Created by Andy on 2016/11/18.
//  Copyright © 2016年 MoDeguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeletePhotoBlock)(NSInteger tag);

@interface XYPostPhotosViewCell : UICollectionViewCell

@property (copy, nonatomic) DeletePhotoBlock deletePhotoBlock;

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UIButton *deleteBtn;

@end
