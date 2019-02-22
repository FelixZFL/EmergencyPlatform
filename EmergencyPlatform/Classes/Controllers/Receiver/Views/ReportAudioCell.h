//
//  ReportAudioCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/15.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioPlayView.h"


@interface ReportAudioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AudioPlayView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;

@property (copy, nonatomic) void(^addAudioBlock)(void);

- (void)setCellDataWithStr:(NSString *)strPath;
@end
 
