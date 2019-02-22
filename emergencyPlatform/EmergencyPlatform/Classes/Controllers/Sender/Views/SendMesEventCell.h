//
//  SendMesEventCell.h
//  EmergencyPlatform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextViewPlaceholder.h"

@interface SendMesEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextViewPlaceholder *emName;
@property (weak, nonatomic) IBOutlet UITextField *category;

@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextViewPlaceholder *address;
@property (weak, nonatomic) IBOutlet UITextViewPlaceholder *intro;
@property (weak, nonatomic) IBOutlet UITextField *level;
@property (weak, nonatomic) IBOutlet UITextViewPlaceholder *phone;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@end
 
