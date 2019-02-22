//
//  GridPhotoView.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GridPhotoView.h"
#import "XYPostPhotosViewCell.h"
#import <UIImageView+WebCache.h>

#define kItemSize  (kScreenWidth-50)/3.0
static NSString *identifier = @"XYPostPhotosViewCell";

@implementation GridPhotoView

- (void)setupSubviews{
    
    [self addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark - 初始化控件
- (UIImage *)addImage{
    if (!_addImage) {
        _addImage = [UIImage imageNamed:@"AlbumAddBtn"];
    }
    return _addImage;
}

- (UICollectionView *)photosView{
    if (!_photosView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 2.5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.itemSize = CGSizeMake(kItemSize, kItemSize);
        
        _photosView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _photosView.backgroundColor = [UIColor clearColor];
        _photosView.allowsMultipleSelection = YES;
        _photosView.showsVerticalScrollIndicator = NO;
        _photosView.delegate = self;
        _photosView.dataSource = self;
        
        [_photosView registerClass:[XYPostPhotosViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _photosView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 1000) {
        textView.text = [textView.text substringToIndex:1000];
    }
}

#pragma mark -- UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYPostPhotosViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([self.photosArray[indexPath.row] isKindOfClass:[NSString class]]) {
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:self.photosArray[indexPath.row]] placeholderImage:kDefaultPhoto];
    }else {
        cell.photo.image = self.photosArray[indexPath.row];
    }
    cell.deleteBtn.tag = indexPath.row;
    if ([self.photosArray containsObject:self.addImage] && indexPath.row == self.photosArray.count-1) {
        cell.deleteBtn.hidden = YES;
    }else {
        cell.deleteBtn.hidden = NO;
    }
    WeakSelf;
    cell.deletePhotoBlock = ^(NSInteger tag){
        [weakSelf.photosArray removeObjectAtIndex:tag];
        [weakSelf setPhotosViewWith:weakSelf.photosArray];
        if (weakSelf.removePhotosBlock) {
            weakSelf.removePhotosBlock(tag);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.photosArray containsObject:self.addImage] && indexPath.row == self.photosArray.count-1 && self.addPhotosBlock) {
        self.addPhotosBlock();
    }
}
- (void)setPhotosViewWith:(NSMutableArray *)photos{
    NSMutableArray *mutiArr = [photos mutableCopy];
    if ([mutiArr containsObject:self.addImage]) {
        [mutiArr removeObject:self.addImage];
    }
    if (mutiArr.count < 9 ) {
        [mutiArr addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
    }
    self.photosArray = mutiArr;
    NSInteger hang = (mutiArr.count-1)/3 + 1;
    [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hang * kItemSize);
    }];
    [self layoutIfNeeded];
    [self.photosView reloadData];
}


@end
