//
//  FindPwdViewController.m
//  EmergencyPlatform
//
//  Created by felix on 2018/9/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FindPwdViewController.h"

#import "ResetPwdViewController.h"


@interface FindPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *msgCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeButton;

@end

@implementation FindPwdViewController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"找回密码";
    
    self.phoneTF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    self.phoneTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.nextButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
    [self.nextButton setCorner:5.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- action

- (IBAction)nextAction:(id)sender {
    if (self.phoneTF.text.length != 11) {
        showFadeOutText(@"请输入手机号", 0, 1);
        return;
    }
    if (self.msgCodeTF.text.length == 0) {
        showFadeOutText(@"请输入短信验证码", 0, 1);
        return;
    }
    ResetPwdViewController *vc = [[ResetPwdViewController alloc] init];
    vc.phone = self.phoneTF.text;
    vc.msgCode = self.msgCodeTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)msgCodeAction:(UIButton *)sender {
    
    if (self.phoneTF.text.length != 11) {
        showFadeOutText(@"请输入手机号", 0, 1);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.phoneTF.text forKey:@"mobile"];
    
    //获取验证码发短信
    [NetWorkManager NetworkPOST:@"user/addverification" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        __block int time = 60;
        __block UIButton *verifybutton = sender;
        verifybutton.enabled = NO;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [verifybutton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    verifybutton.enabled = YES;
                });
            }else{
                
                time--;
                int seconds = time % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *strTime = [NSString stringWithFormat:@"%d秒后重发",seconds];
                    [verifybutton setTitle:strTime forState:UIControlStateNormal];
                });
            }
        });
        dispatch_resume(_timer);
        
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
    
    if (textField == self.phoneTF) {
        if (newString.length == 11 && self.msgCodeTF.text.length > 0) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = COLOR_COMMONRED;
        }else {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        }
        
        if (newString.length > 11) {
            return NO;
        }
    } else if (textField == self.msgCodeTF) {
        if (self.phoneTF.text.length == 11 && newString.length > 0) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = COLOR_COMMONRED;
        }else {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = COLOR_TEXT_LIGHTGRAY;
        }
    }
    
    return YES;
}

@end
