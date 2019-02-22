//
//  AudioPlayCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/15.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayView.h"

@interface AudioPlayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet AudioPlayView *bagView;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;

@end
