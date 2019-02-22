//
//  BaseNavigationController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/**
 这个方法只会在类第一次使用的时候调用
 */
+ (void)initialize{
    [super initialize];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    //ios7.0下的导航栏默认是半透明的，设为NO
    navBar.translucent = NO;
    //设置导航栏字体颜色
    [navBar setTitleTextAttributes:@{NSFontAttributeName:FONT_20,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置导航栏背景颜色
    navBar.barTintColor = COLOR_COMMONRED;
    //去掉透明后导航栏下边的黑边（全局作用域）
    [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
