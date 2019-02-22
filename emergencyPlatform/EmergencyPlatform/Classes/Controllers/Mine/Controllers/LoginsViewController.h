//
//  LoginsViewController.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
