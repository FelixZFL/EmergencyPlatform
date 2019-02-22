//
//  ResetPwdViewController.m
//  EmergencyPlatform
//
//  Created by felix on 2018/9/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "NSString+Additions.h"

@interface ResetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ResetPwdViewController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"重置密码";
    
    self.submitButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
    [self.submitButton setCorner:5.f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- action
- (IBAction)submitAction:(UIButton *)sender {
    if (self.passwordTF.text.length == 0) {
        showFadeOutText(@"请输入重置密码", 0, 1);
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.rePasswordTF.text]) {
        if (self.passwordTF.text.length == 0) {
            showFadeOutText(@"两次密码不一致", 0, 1);
            return;
        }
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];

    [params setObject:self.phone forKey:@"mobile"];
    [params setObject:self.msgCode forKey:@"code"];

    NSString *md5Pwd = [self.passwordTF.text md5];
    [params setObject:md5Pwd forKey:@"password"];
    
    [NetWorkManager NetworkPOST:@"user/resetPwd" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
    
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = textField.text;
    if (string.length > 0) {
        newString = [NSString stringWithFormat:@"%@%@",newString,string];
    }else {//删除
        newString = [newString substringToIndex:range.location];
    }
    NSLog(@"newString -- %@",newString);
    
    if (textField == self.passwordTF) {
        if (newString.length > 0 && self.rePasswordTF.text.length > 0) {
            self.submitButton.userInteractionEnabled = YES;
            self.submitButton.backgroundColor = COLOR_COMMONRED;
        }else {
            self.submitButton.userInteractionEnabled = YES;
            self.submitButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        }
    } else if (textField == self.rePasswordTF) {
        if (self.passwordTF.text.length > 0 && newString.length > 0) {
            self.submitButton.userInteractionEnabled = YES;
            self.submitButton.backgroundColor = COLOR_COMMONRED;
        }else {
            self.submitButton.userInteractionEnabled = YES;
            self.submitButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        }
    }
    
    return YES;
}


@end
