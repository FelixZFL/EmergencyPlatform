//
//  JuReportImageCell.h
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/24.
//  Copyright © 2018年 aifubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuReportImageCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    __weak IBOutlet NSLayoutConstraint *ju_layCollectH;
    __weak IBOutlet UICollectionView *ju_collectView;
}
@property (nonatomic,weak) NSMutableArray *ju_arrList;
@end
