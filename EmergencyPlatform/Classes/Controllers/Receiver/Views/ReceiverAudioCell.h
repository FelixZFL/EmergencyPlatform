//
//  ReceiverAudioCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveMesDTO.h"

@interface ReceiverAudioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mesImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *mark;

- (void)setCellDataWith:(ReceiveMesDTO *)data;
@end
