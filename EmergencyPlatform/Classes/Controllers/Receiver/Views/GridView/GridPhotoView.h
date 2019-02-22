//
//  GridPhotoView.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseView.h"

typedef void(^AddPhotosBlock)();
typedef void(^RemovePhotosBlock)(NSInteger index);

@interface GridPhotoView : BaseView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (copy, nonatomic) AddPhotosBlock addPhotosBlock;
@property (copy, nonatomic) RemovePhotosBlock removePhotosBlock;
@property (strong, nonatomic) NSMutableArray *photosArray;

@property (strong, nonatomic) UICollectionView *photosView;
@property (strong, nonatomic) UIImage *addImage;

- (void)setPhotosViewWith:(NSMutableArray *)photos;

@end
