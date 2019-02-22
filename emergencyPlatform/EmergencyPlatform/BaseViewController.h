//
//  BaseViewController.h
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import <UIViewController+JZExtension.h>

@interface BaseViewController : UIViewController
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIButton *rightBtn1;
@property (strong, nonatomic) UIButton *rightBtn2;

@property (copy, nonatomic) NSString *record;//页面的具体行为值

- (BOOL)needHiddenNavigationBar;
- (float)getNavigationBarHeight;
- (float)getViewHeight;
- (float)getToolBarHeight;
- (BOOL)needShowBackButton;
- (void)goBack;
- (void)initNavigationBar;
- (BOOL)needShowCloseButton;

@property (nonatomic, strong) UIFont *fou;
- (void)showLoadddingView;
- (void)hiddenLoaddingView;
- (BOOL)checkValueIsNull:(NSObject *)value;
- (void)closeView;

- (void)clickRightBtn1;
- (void)clickRightBtn2;
@end
