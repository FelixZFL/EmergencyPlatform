//
//  AudioReceiverCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioReceiverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiverName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNameConstraint;

- (void)setCellDataWith:(NSString *)data;
@end
