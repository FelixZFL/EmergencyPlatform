//
//  MineViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/6/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MineViewController.h"
#import "LoginsViewController.h"
#import "MineInfoCell.h"
#import "MineTableCell.h"
#import "UserInfoManager.h"
#import "TeamUserDTO.h"
#import "LogOutView.h"

#define kBottomViewHit  50
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TeamUserDTO *userModel;
@property (strong, nonatomic) LogOutView *logOutView;
@end

@implementation MineViewController
- (BOOL)needShowBackButton {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableFooterView = self.logOutView;
    
    WeakSelf;
    self.logOutView.clickBtnslBlock = ^{
        [UserInfoManager loginOut];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf setupLoginViewController];
    };
    [self requestMineInfo];
}
- (void)setNavView{
    self.navigationItem.title = @"收到通知";
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (LogOutView *)logOutView{
    if (!_logOutView) {
        _logOutView = [[LogOutView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 100)];
        _logOutView.backgroundColor = [UIColor whiteColor];
    }
    return _logOutView;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    } else {
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"MineInfoCell";
        MineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageTapAction)]];
        }
        [cell setCellDataWith:self.userModel];
        return cell;
    } else {
        static NSString *identifier = @"MineTableCell";
        MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWith:indexPath.row user:self.userModel];
        return cell;
    }
}
- (void)requestMineInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userid"];
    
    [NetWorkManager NetworkPOST:@"user/getbyid" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        self.userModel = [TeamUserDTO mj_objectWithKeyValues:result[@"resultdata"]];
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
//进入登录页面
- (void)setupLoginViewController
{
    LoginsViewController *loginController = [[LoginsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.view.window.rootViewController = nav;
}

- (void)userImageTapAction {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self choosePhotoType:1];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相册中获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choosePhotoType:2];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
    
}

- (void)choosePhotoType:(NSInteger)type{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self uploadImage:image];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)uploadImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *base64Encode = [imageData base64EncodedStringWithOptions:0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:base64Encode forKey:@"img"];
    
    [NetWorkManager NetworkPOST:@"noticereport/upload" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        NSString *imgUrl = result[@"resultdata"];
        [self updateHeadImageWithUrl:imgUrl];
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"上传失败，请重试", 0, 1);
    }];
}

- (void)updateHeadImageWithUrl:(NSString *)urlStr {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userID"];
    [params setObject:urlStr forKey:@"header"];
    [NetWorkManager NetworkPOST:@"user/updateHeader" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [self requestMineInfo];
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
