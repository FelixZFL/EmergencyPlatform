//
//  JuReportImageCell.m
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/24.
//  Copyright © 2018年 aifubao. All rights reserved.
//

#import "JuReportImageCell.h"
#import "JuImageItemCVCell.h"
#import "JuReportImageModel.h"
#import "PYPhotoBrowseView.h"

static NSString *itemCollectCell = @"JuImageItemCVCell";


@interface JuReportImageCell ()<PYPhotoBrowseViewDataSource,PYPhotoBrowseViewDelegate>{
    NSInteger ju_currentIndex;
}
@end
@implementation JuReportImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self juSetCollectViewLayout];
    // Initialization code
}

-(void)juSetCollectViewLayout{
    [ju_collectView registerNib:[UINib nibWithNibName:itemCollectCell bundle:nil]  forCellWithReuseIdentifier:itemCollectCell];//cell重用设置ID
    ju_collectView.scrollEnabled=NO;
    ju_collectView.delegate = self;//实现网格视图的delegate
    ju_collectView.dataSource = self;//实现网格视图的dataSource
    ju_collectView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout * sh_layout = (UICollectionViewFlowLayout *)ju_collectView.collectionViewLayout;
    sh_layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    sh_layout.itemSize =CGSizeMake(SHItemSize, SHItemSize);;
    sh_layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    sh_layout.minimumLineSpacing=10;//   行间距
    sh_layout.minimumInteritemSpacing=10;//    内部cell间距
}
-(void)setJu_arrList:(NSMutableArray *)ju_arrList{
    _ju_arrList=ju_arrList;
    NSInteger line=(_ju_arrList.count-1)/3+1;
    CGFloat collectH=line*(SHItemSize+10);
    ju_layCollectH.constant=collectH;
    [ju_collectView reloadData];
}
#pragma mark collectionView Delegate &datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _ju_arrList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JuImageItemCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCollectCell forIndexPath:indexPath];
    JuReportImageModel *juM=_ju_arrList[indexPath.row];
    [cell juSetUrlImage:juM.img];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PYPhotoBrowseView *view=[[PYPhotoBrowseView alloc]init];
    NSMutableArray *arrList=[NSMutableArray array];
    for (JuReportImageModel *shM in _ju_arrList) {
        [arrList addObject:shM.img];
    }
    view.imagesURL=arrList;
    view.currentIndex=indexPath.row;
    view.dataSource=self;
    view.delegate=self;
    [view show];
}
/** 默认显示图片相对于主窗口的位置 */
- (CGRect)frameFormWindow{
    UICollectionViewCell *cell=[ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:ju_currentIndex inSection:0]];
    CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
    return frame;
}

/** 消失回到相对于住窗口的指定位置 */
- (CGRect)frameToWindow{
    UICollectionViewCell *cell=[ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:ju_currentIndex inSection:0]];
    CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
    return frame;
}
/** 返回默认显示图片的索引(默认为0) */
/**
 * 图片浏览将要显示时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willShowWithImages:(NSArray *)images index:(NSInteger)index{
    ju_currentIndex=index;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
