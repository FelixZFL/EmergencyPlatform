//
//  ReportContentCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PYPhotoBrowser.h>
#import "ReportMesDTO.h"
#import "AudioPlayView.h"

@interface ReportContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *reportTime;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet AudioPlayView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightCons;
@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewHit;
@property (strong, nonatomic) PYPhotosView *flowPhotosView;
@property (strong, nonatomic) NSMutableArray *photosArray;

- (void)setCellDataWith:(ReportMesDTO *)data;
@end
   
