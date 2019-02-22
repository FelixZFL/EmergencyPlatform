//
//  BaseViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property (nullable, nonatomic, weak) id <UIGestureRecognizerDelegate> delegate;

@end

@implementation BaseViewController

- (BOOL)needHiddenNavigationBar {
    return NO;
}
- (float)getNavigationBarHeight {
    return self.navigationController.navigationBar.frame.size.height+20;
}

- (float)getToolBarHeight {
    return self.tabBarController.tabBar.frame.size.height;
}

- (float)getViewHeight {
    return self.view.frame.size.height - [self getNavigationBarHeight] - [self getToolBarHeight];
}

- (void)initNavigationBar {
}

- (BOOL)needShowCloseButton {
    return NO;
}

- (BOOL)needShowBackButton {
    if ([self needHiddenNavigationBar] == YES) {
        NO;
    }
    return YES;
}
//为每个页面配置友盟统计
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) { // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;// 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];//设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count <= 1) {
        //关闭ios右滑返回
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.delegate=self;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.navigationController.viewControllers.count <= 1) {
        //开启ios右滑返回
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //左滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //设置背景色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([self needShowCloseButton]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];
    } else if ([self needShowBackButton]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    } else {
        [self.tabBarController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
    }
}
- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtn1{
    //子类重写
}
- (void)clickRightBtn2{
    //子类重写
}
- (void)receiveNotification:(NSNotification *)notification{
    //子类重写
}

- (BOOL)checkValueIsNull:(NSObject *)value {
    if (value == nil) {
        return YES;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.childViewControllers.count > 1) {
        return YES;
    }else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - liushuoAdd

- (UIButton *)backBtn{
    if (!_backBtn) {
        //_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        //_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.titleLabel.font = FONT_14;
        [_closeBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)rightBtn1{
    if (!_rightBtn1) {
        //_rightBtn1 = [ UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _rightBtn1.backgroundColor = [UIColor clearColor];
        _rightBtn1.titleLabel.font = FONT_14;
        [_rightBtn1 setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_rightBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_rightBtn1 setImage:[UIImage imageNamed:@"more_black"] forState:UIControlStateNormal];
        [_rightBtn1 addTarget:self action:@selector(clickRightBtn1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn1;
}

- (UIButton *)rightBtn2{
    if (!_rightBtn2) {
        //_rightBtn2 = [ UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _rightBtn2.backgroundColor = [UIColor clearColor];
        [_rightBtn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_rightBtn2 addTarget:self action:@selector(clickRightBtn2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn2;
}

@end
