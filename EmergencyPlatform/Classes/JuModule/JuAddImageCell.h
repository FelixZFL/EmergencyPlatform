//
//  JuAddImageCell.h
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuImageItemCVCell.h"
@interface JuAddImageCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    __weak IBOutlet UICollectionView *ju_collectView;
    __weak IBOutlet NSLayoutConstraint *ju_layCollectH;
}
@property (nonatomic,weak) UIViewController *ju_supVc;
@property (nonatomic,weak) NSMutableArray *ju_arrList;
@property (nonatomic,copy  ) dispatch_block_t ju_handle;//刷新数据
-(void)juSetCellImage:(NSMutableArray *)images supVc:(UIViewController *)supVc handle:(dispatch_block_t)handle;
@end
 
