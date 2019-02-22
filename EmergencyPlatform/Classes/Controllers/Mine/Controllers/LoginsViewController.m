//
//  LoginsViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LoginsViewController.h"
#import "MainViewController.h"
#import "NSString+Additions.h"
#import "UserInfoManager.h"
#import "JuPushConfig.h"
#import "AppDelegate.h"

#import "FindPwdViewController.h"

@interface LoginsViewController ()

@end

@implementation LoginsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (IsProduction) {
        self.accountText.text=@"";
        self.pwdText.text=@"";
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _accountView.layer.borderWidth = 1.0;
    _accountView.layer.borderColor = COLOR_COMMONRED.CGColor;
    _accountView.layer.cornerRadius = 5;
    
    _pwdView.layer.borderWidth = 1.0;
    _pwdView.layer.borderColor = COLOR_COMMONRED.CGColor;
    _pwdView.layer.cornerRadius = 5;
    
#ifdef DEBUG
//    self.accountText.text=@"18108134058";
//    self.pwdText.text=@"123456";
            self.accountText.text=@"17778349785";
            self.pwdText.text=@"123456";
#else
#endif

}
- (IBAction)forgetPwd:(id)sender {
    FindPwdViewController *vc = [[FindPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginPress:(id)sender {
    [self loginRequest];
}
- (void)loginRequest {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:_accountText.text forKey:@"userName"];
    
    NSString *md5Pwd = [_pwdText.text md5];
    [params setObject:md5Pwd forKey:@"password"];
    
    [NetWorkManager NetworkPOST:@"user/login" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:result[@"resultdata"]];
        [UserInfoManager configInfo:userInfo];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:UserID]) {
            NSLog(@"用户处于登录状态--用户的真实姓名为：%@",[[UserInfoManager shareUser] userName]);
        }else{
            NSLog(@"用户处于非登录状态，进行非登录状态的处理");
        }
        
        //存储token
        NSString *accessToken = result[@"resultdata"][@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:AccessToken];
        
        NSString *userID = result[@"resultdata"][@"userID"];
        [[NSUserDefaults standardUserDefaults]setObject:userID forKey:UserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [JuPush_Config shJPushSetAlias];///设置push别名
        //跳主页
        MainViewController *mainTab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
         AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = mainTab;
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
