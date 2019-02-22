//
//  DNAlbumTableViewController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/10.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNAlbumTableViewController : UITableViewController

//记录已选择图片张数
@property (nonatomic, assign) NSInteger picCount;
//选择图片张数限制
@property (nonatomic, assign) NSInteger selectMaxCount;

@end
