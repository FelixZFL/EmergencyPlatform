//
//  SceneReportViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SceneReportViewController.h"
#import "DNImagePickerController.h"
#import "AudioCallViewController.h"
#import "UserInfoManager.h"
#import "NoticeBottomView.h"
#import "ReportTextCell.h"
#import "ReportAudioCell.h"
#import "GridPhotoView.h"
#import "XYAudioPlayer.h"
#import "SystemHelper.h"
#import "JuAddImageCell.h"


#define kBottomViewHit  72
@interface SceneReportViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,XYAudioPlayerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DNImagePickerControllerDelegate>{
    NSInteger ju_currentImageIndex;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NoticeBottomView *bootomView;
@property (nonatomic, strong) GridPhotoView *gridPhotoView;
@property (copy, nonatomic) NSString *strAudioPathFile;

@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (strong, nonatomic) NSMutableArray *imgs;

@property (copy, nonatomic) NSString *ju_localUrl;
@property (strong,nonatomic) NSMutableArray *ju_arrImages;

@end

@implementation SceneReportViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //实现播放器代理
    [XYAudioPlayer sharePlayer].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止播放器
    [[XYAudioPlayer sharePlayer] stopAudioPlayer];
    //删除近距离事件监听（语音未播完界面变化时强制删除）
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    
    [self.view addSubview:self.tableView];
      WeakSelf;
    /*self.tableView.tableFooterView = self.gridPhotoView;
    [self.view addSubview:self.bootomView];

    [self.gridPhotoView setPhotosViewWith:self.selectedPhotos];

    self.gridPhotoView.addPhotosBlock = ^{
        [weakSelf imagePicker];
    };
    self.gridPhotoView.removePhotosBlock = ^(NSInteger index){
        [weakSelf.selectedPhotos removeObjectAtIndex:index];
    };*/
     [self.view addSubview:self.bootomView];
    self.bootomView.checkInBtn.enabled = NO;
    self.bootomView.checkInBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
    self.bootomView.checkInBtn.titleLabel.font = FONT_18;
    [self.bootomView.checkInBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.bootomView.reportBtn setTitle:@"确认上报" forState:UIControlStateNormal];
    
    self.bootomView.clickBtnslBlock = ^(NSInteger tag) {
        if (tag == 0) {
            //重置
            ReportTextCell *cell = [weakSelf getFirstResponderField:0];
            cell.contentText.text = @"";
        } else {
            //上报
            [weakSelf reportMes];
        }
    };
}
- (void)setNavView{
    self.navigationItem.title = @"现场情况上报";
}
#pragma mark - 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomViewHit-kNav);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JuAddImageCell" bundle:nil] forCellReuseIdentifier:@"JuAddImageCell"];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReportTextCell class]) bundle:nil] forCellReuseIdentifier:@"ReportTextCell"];
    }
    return _tableView;
}
- (NoticeBottomView *)bootomView{
    if (!_bootomView) {
        _bootomView = [[NoticeBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kBottomViewHit-kNav, kScreenWidth, kBottomViewHit)];
        _bootomView.backgroundColor = [UIColor whiteColor];
    }
    return _bootomView;
}
- (GridPhotoView *)gridPhotoView{
    if (!_gridPhotoView) {
        _gridPhotoView = [[GridPhotoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _gridPhotoView.backgroundColor = [UIColor whiteColor];
    }
    return _gridPhotoView;
}
- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}
- (NSMutableArray *)imgs{
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
    if (indexPath.section ==0) {
        static NSString *identifier = @"ReportTextCell";
        ReportTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        cell.contentText.delegate = self;
        return cell;
    } else if(indexPath.section==1) {
        static NSString *identifier = @"ReportAudioCell";
        ReportAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        [cell setCellDataWithStr:self.strAudioPathFile];
        cell.bgView.audioUrl = self.strAudioPathFile;
        WeakSelf;
        cell.addAudioBlock = ^{
            //路音频
            [weakSelf gotoRecordAudio];
        };
        return cell;
    }else{
        JuAddImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JuAddImageCell"];
        [cell juSetCellImage:self.ju_arrImages supVc:self handle:^{
             [tableView reloadData];
        }];
        return cell;
    }
}

-(NSMutableArray *)ju_arrImages{
    if (!_ju_arrImages) {
        _ju_arrImages=[NSMutableArray array];
    }
    return _ju_arrImages;
}
- (void)gotoRecordAudio {
    AudioCallViewController *controller = [[AudioCallViewController alloc] init];
    controller.isAudio = YES;
    WeakSelf;
//    controller.refreshAudioPathBlock = ^(NSString *str) {
//        weakSelf.strAudioPathFile = str;
//        [weakSelf.tableView reloadData];
//    };
    controller.refreshAudioPathBlock = ^(NSString *str, NSString *locationUrl) {
         weakSelf.strAudioPathFile = str;
        weakSelf.ju_localUrl=locationUrl;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)juUploadImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *base64Encode = [imageData base64EncodedStringWithOptions:0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:base64Encode forKey:@"img"];
    
    [NetWorkManager NetworkPOST:@"noticereport/upload" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        self->ju_currentImageIndex++;
        NSString *imgUrl = result[@"resultdata"];
        [self.imgs addObject:imgUrl];
        if(self->ju_currentImageIndex<self.ju_arrImages.count){
            [self juUploadImage:self.ju_arrImages[self->ju_currentImageIndex]];
        }else{
            [self juSendReport];
        }
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送失败，请重试", 0, 1);
    }];
}
-(void)juSendReport{
    ReportTextCell *cell = [self getFirstResponderField:0];
    UITextView *mesContent = cell.contentText;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.mesDto.noticeID forKey:@"noticeID"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserID] forKey:@"userID"];
    [params setObject:mesContent.text forKey:@"content"];
    [params setValue:self.strAudioPathFile forKey:@"avi"];
    [params setObject:@"1" forKey:@"audioSize"];

    __block NSString *imgString = @"";
    [self.imgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.imgs.count-1) {
            imgString = [imgString stringByAppendingFormat:@"%@",obj];
        }else {
            imgString = [imgString stringByAppendingFormat:@"%@,",obj];
        }
    }];
    if (!IsStrEmpty(imgString)) {
        [params setObject:imgString forKey:@"imgs"];
    }

    [NetWorkManager NetworkPOST:@"noticereport/addnoticereport" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        if (self.reportSuccessBlock) {
            self.reportSuccessBlock();
        }
        showFadeOutText(@"上报成功", 0, 3);
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}
- (void)reportMes {
    ReportTextCell *cell = [self getFirstResponderField:0];
    UITextView *mesContent = cell.contentText;
    if (IsStrEmpty(mesContent.text)) {
        showFadeOutText(@"上报内容不能为空", 0, 3);
        return;
    }
    
    if (self.ju_arrImages.count>0) {
        ju_currentImageIndex=0;
        [self juUploadImage:_ju_arrImages[ju_currentImageIndex]];
    } else {
        [self juSendReport];
    }
}
- (ReportTextCell *)getFirstResponderField:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ReportTextCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
#pragma mark - UIActionSheetDelegate
/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1) {
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate = self;
        imagePicker.filterType = DNImagePickerFilterTypePhotos;
        imagePicker.selectMaxCount = 9; //限制最大张数
        imagePicker.picCount = self.selectedPhotos.count;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //把图片存到图片库
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        UIImage *tempImage = [SystemHelper convertImage:image scope:640.0];
        [self.selectedPhotos addObject:tempImage];
        
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.8);
        [self sendImgOneByOne:imageData];
        
        [self.gridPhotoView setPhotosViewWith:self.selectedPhotos];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker
                     sendImages:(NSArray *)imageAssets
                    isFullImage:(BOOL)fullImage imageArray:(NSArray *)imageArray {
    for (UIImage *image in imageArray) {
        UIImage *tempImage = [SystemHelper convertImage:image scope:640.0];
        [self.selectedPhotos addObject:tempImage];
        
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.8);
        [self sendImgOneByOne:imageData];
    }
    [self.gridPhotoView setPhotosViewWith:self.selectedPhotos];
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- Actions
- (void)imagePicker{
    //排除键盘干扰
    [self.view endEditing:YES];
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    pickImageSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [pickImageSheet showInView:self.view];
}

//上传图片
- (void)sendImgOneByOne:(NSData *)imgData {
    //根据NSData生成Base64编码的String
    NSString *base64Encode = [imgData base64EncodedStringWithOptions:0];
    NSLog(@"Encode:%@", base64Encode);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:base64Encode forKey:@"img"];
    
    [NetWorkManager NetworkPOST:@"noticereport/upload" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        
        NSString *imgUrl = result[@"resultdata"];
        [self.imgs addObject:imgUrl];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送失败，请重试", 0, 1);
    }];
}*/
@end
