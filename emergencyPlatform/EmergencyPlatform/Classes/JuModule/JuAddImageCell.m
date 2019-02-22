//
//  JuAddImageCell.m
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JuAddImageCell.h"
#import "JuImageItemCVCell.h"
#import "DNImagePickerController.h"
#import "SystemHelper.h"

static NSString *itemCollectCell = @"JuImageItemCVCell";

@interface JuAddImageCell ()<DNImagePickerControllerDelegate>

@end

@implementation JuAddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self juSetCollectViewLayout];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
//-(void)juSetContentCell:(id)images{
// 
//    [ju_collectView reloadData];
//}
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

-(void)juSetCellImage:(NSMutableArray *)images supVc:(UIViewController *)supVc handle:(dispatch_block_t)handle{
    self.ju_arrList=images;
    self.ju_supVc=supVc;
    self.ju_handle=handle;
}
-(void)setJu_arrList:(NSMutableArray *)ju_arrList{
    _ju_arrList=ju_arrList;
    NSInteger line=(_ju_arrList.count)/3+1;
    CGFloat collectH=line*(SHItemSize+10);
    ju_layCollectH.constant=collectH;
    [ju_collectView reloadData];
}
#pragma mark collectionView Delegate &datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _ju_arrList.count+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JuImageItemCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCollectCell forIndexPath:indexPath];
    if (indexPath.row!=_ju_arrList.count) {
        [cell juSetCollentImage:_ju_arrList[indexPath.row]];
    }
    [cell juIsAddImage:indexPath.row==_ju_arrList.count ];
    cell.ju_handle = ^(id image) {
        [self.ju_arrList removeObject:image];
        if (self.ju_handle) {
            self.ju_handle();
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_ju_arrList.count) {///< 添加图片
        if (_ju_arrList.count==9) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"最多可以选择9张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
         DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate = self;
        imagePicker.filterType = DNImagePickerFilterTypePhotos;
        imagePicker.selectMaxCount = 9; //限制最大张数
         imagePicker.picCount = self.ju_arrList.count;
        [_ju_supVc  presentViewController:imagePicker animated:YES completion:nil];

    }else{///< 查看图片 暂时未实现
        
    }
}

    
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //把图片存到图片库
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
       [self juAddImage:image];
    }
    [_ju_supVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker
                     sendImages:(NSArray *)imageAssets
                    isFullImage:(BOOL)fullImage imageArray:(NSArray *)imageArray {
    for (UIImage *image in imageArray) {
        [self juAddImage:image];
    }
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)juAddImage:(UIImage *)image{
        UIImage *tempImage = [SystemHelper convertImage:image scope:640.0];
        [self.ju_arrList addObject:tempImage];
        if (self.ju_handle) {
            self.ju_handle();
        }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
