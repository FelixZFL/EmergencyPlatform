//
//  SendMesAudioCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveMesDTO.h"

@interface SendMesAudioCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mesImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *markLbl;

- (void)setCellDataWith:(ReceiveMesDTO *)data;

@end
