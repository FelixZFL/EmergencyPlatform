//
//  SendMesDetailViewController.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SendMesDetailViewController.h"
#import "MapChooseAddressViewController.h"
#import "SendMesContentCell.h"
#import "SendMesEventCell.h"
#import "NoticeBottomView.h"
#import "AddressDTO.h"
#import "UITextViewPlaceholder.h"
//#import "THDatePickerView.h"
#import "DatePickerView.h"
#import "CategoryDTO.h"
#import "XYCategoryMenu.h"

#define kBottomViewHit  72
@interface SendMesDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>//THDatePickerViewDelegate

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NoticeBottomView *bootomView;
//@property (weak, nonatomic) THDatePickerView *dateView;
@property (strong, nonatomic) DatePickerView *dateView;
@property (strong, nonatomic) AddressDTO *aggregateAddress;
@property (strong, nonatomic) AddressDTO *address;
//@property (nonatomic) BOOL isFirst;
@property (strong, nonatomic) NSMutableArray<CategoryDTO *> *categoryArr;
@property (strong, nonatomic) NSMutableArray<CategoryDTO *> *emergencyArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *levelItems;
@end

@implementation SendMesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bootomView];
    
    self.bootomView.checkInBtn.backgroundColor = COLOR_TEXT_LIGHTGRAY;
    self.bootomView.checkInBtn.titleLabel.font = FONT_18;
    [self.bootomView.checkInBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.bootomView.reportBtn setTitle:@"确认发送" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    WeakSelf;
    self.bootomView.clickBtnslBlock = ^(NSInteger tag) {
        if (tag ==0) {
            //重置
            [weakSelf resetAll];
        } else {
            [weakSelf reportMes];
        }
    };
    
//    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, 300)];
//    dateView.delegate = self;
//    dateView.title = @"请选择时间";
//    [self.view addSubview:dateView];
//    self.dateView = dateView;
    
//    self.dateView.frame = CGRectMake(0, 0, kScreenWidth, 260);
//    [self.view addSubview:self.dateView];
    
    [self getCategory];
}
- (void)setNavView{
    self.navigationItem.title = @"群发通知";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (NSMutableArray<CategoryDTO *> *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}
- (NSMutableArray<CategoryDTO *> *)emergencyArr{
    if (!_emergencyArr) {
        _emergencyArr = [NSMutableArray array];
    }
    return _emergencyArr;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    if (indexPath.section == 0) {
        static NSString *identifier = @"SendMesContentCell";
        SendMesContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        cell.time.delegate = self;
        cell.address.delegate = self;
        WEAK
        [[[cell.mapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            STRONG
            [self gotToLocationMap:indexPath.section];
        }];
        cell.receiver.text = self.userNameStr;
        return cell;
    } else {
        static NSString *identifier = @"SendMesEventCell";
        SendMesEventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        }
        cell.time.delegate = self;
        cell.category.delegate = self;
        cell.level.delegate = self;
        cell.address.delegate = self;
        WEAK
        [[[cell.mapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            STRONG
            [self gotToLocationMap:indexPath.section];
        }];
        return cell;
    }
}

#pragma mark - 键盘弹出通知

- (void)keyboardWillShow:(NSNotification *)notif {
//    self.dateView.frame = CGRectMake(0, kScreenHeight, self.view.frame.size.width, 300);
    [self.dateView removeFromSuperview];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self gotToLocationMap:1];
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    //写你要实现的：页面跳转的相关代码
    SendMesContentCell *cell = [self getFirstResponderField:0];
    if (textField == cell.time) {
        [self.view endEditing:YES];
//        self.isFirst = YES;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//            [self.dateView show];
//        }];
        self.dateView.type = DatePickerViewType_cannotChooseAgo;
        [self.view addSubview:self.dateView];
        [_dateView setChoosedBlock:^(NSString *chooseTime) {
            textField.text = chooseTime;
        }];
    }
    
    SendMesEventCell *second = [self getSecondResponderField:0];
    if (textField == second.time) {
        [self.view endEditing:YES];
//        self.isFirst = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//            [self.dateView show];
//        }];
        self.dateView.type = DatePickerViewType_cannotChooseFuture;
        [self.view addSubview:self.dateView];
        [_dateView setChoosedBlock:^(NSString *chooseTime) {
            textField.text = chooseTime;
        }];
    }
    
    if (textField == cell.address) {
        [self gotToLocationMap:0];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView  convertRect:rectInTableView toView:[self.tableView superview]];
    
    WeakSelf;
    if (textField == second.category) {
        [self.view endEditing:YES];
//        self.dateView.frame = CGRectMake(0, kScreenHeight, self.view.frame.size.width, 300);
        [self.dateView removeFromSuperview];
        [XYCategoryMenu setSelectedColor:[UIColor blackColor]];
        [XYCategoryMenu showMenuInView:weakSelf.view fromRect:CGRectMake(kScreenWidth - 88, rect.origin.y+90, 78, 0) menuItems:weakSelf.items selected:^(NSInteger index, XYMenuItem *item) {
            second.category.text = item.title;
        }];
    }
    if (textField == second.level) {
        [self.view endEditing:YES];
//        self.dateView.frame = CGRectMake(0, kScreenHeight, self.view.frame.size.width, 300);
        [self.dateView removeFromSuperview];
        [XYCategoryMenu setSelectedColor:[UIColor blackColor]];
        [XYCategoryMenu showMenuInView:weakSelf.view fromRect:CGRectMake(kScreenWidth - 88, rect.origin.y+358, 78, 0) menuItems:weakSelf.levelItems selected:^(NSInteger index, XYMenuItem *item) {
            second.level.text = item.title;
        }];
    }
    return NO;
}
//#pragma mark - THDatePickerViewDelegate
///**
// 保存按钮代理方法
//
// @param timer 选择的数据
// */
//- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
//    if (self.isFirst) {
//        SendMesContentCell *cell = [self getFirstResponderField:0];
//        cell.time.text = timer;
//    } else {
//        SendMesEventCell *second = [self getSecondResponderField:0];
//        second.time.text = timer;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
//    }];
//}
//
///**
// 取消按钮代理方法
// */
//- (void)datePickerViewCancelBtnClickDelegate {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
//    }];
//}
- (void)gotToLocationMap:(NSInteger)section {
    
    MapChooseAddressViewController *controller = [[MapChooseAddressViewController alloc] init];
    WeakSelf;
    controller.refreshAddressBlock = ^(AddressDTO *address) {
        if (section == 0) {
            weakSelf.aggregateAddress = [[AddressDTO alloc] init];
            weakSelf.aggregateAddress = address;
            
            SendMesContentCell *secondCell= [weakSelf getFirstResponderField:0];
            secondCell.address.text = address.address;
        } else {
            weakSelf.address = [[AddressDTO alloc] init];
            weakSelf.address = address;
            
            SendMesEventCell *secondCell= [weakSelf getSecondResponderField:0];
            secondCell.address.text = address.address;
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (SendMesContentCell *)getFirstResponderField:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    SendMesContentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
- (SendMesEventCell *)getSecondResponderField:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
    SendMesEventCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)resetAll {
    SendMesContentCell *cell = [self getFirstResponderField:0];
    cell.title.text = @"";
    cell.time.text = @"";
    cell.address.text = @"";
    
    SendMesEventCell *secondCell= [self getSecondResponderField:0];
    secondCell.emName.text = @"";
    secondCell.category.text = @"";
    secondCell.time.text = @"";
    secondCell.address.text = @"";
    secondCell.intro.text = @"";
    secondCell.level.text = @"";
    secondCell.phone.text = @"";
}
- (void)reportMes {
    SendMesContentCell *cell = [self getFirstResponderField:0];
    UITextView *mesContent = cell.title;
    UITextField *jiheTime = cell.time;
    UITextField *jiheAddress = cell.address;
    
    SendMesEventCell *secondCell= [self getSecondResponderField:0];
    UITextViewPlaceholder *eventName = secondCell.emName;
    UITextField *eventCategory = secondCell.category;
    UITextField *eventTime = secondCell.time;
    UITextViewPlaceholder *eventAddress = secondCell.address;
    UITextViewPlaceholder *eventIntro = secondCell.intro;
    UITextField *eventLevel = secondCell.level;
    UITextViewPlaceholder *eventPhone = secondCell.phone;
    
    
    //提交信息
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%@:00",jiheTime.text] forKey:@"aggregateTime"];
    [params setObject:[NSString stringWithFormat:@"%@:00",eventTime.text] forKey:@"createTime"];
    [params setObject:[NSString stringWithFormat:@"%@:00",eventTime.text] forKey:@"generatedTime"];
    
    [params setObject:jiheAddress.text forKey:@"aggregateaddress"];
    [params setObject:[NSString stringWithFormat:@"%f",self.aggregateAddress.lng] forKey:@"aggregateLng"];
    [params setObject:[NSString stringWithFormat:@"%f",self.aggregateAddress.lat] forKey:@"aggregateLat"];
    [params setObject:mesContent.text forKey:@"notice"];
    [params setObject:eventName.text forKey:@"title"];
    [params setObject:eventIntro.text forKey:@"preliminary"];
    [params setObject:eventCategory.text forKey:@"category"];
    [params setObject:eventAddress.text forKey:@"address"];
    [params setObject:[NSString stringWithFormat:@"%f",self.address.lng] forKey:@"lng"];
    [params setObject:[NSString stringWithFormat:@"%f",self.address.lat] forKey:@"lat"];
    
    [params setObject:eventIntro.text forKey:@"preliminary"];
    [params setObject:eventLevel.text forKey:@"grade"];
    [params setObject:eventPhone.text forKey:@"telephone"];
    [params setObject:@(0) forKey:@"classic"];
    [params setObject:self.paraString forKey:@"Users"];
    [params setObject:@"1" forKey:@"audioSize"];
    
    
    [NetWorkManager NetworkPOST:@"notice/addnotice" parameters:params startHander:^{
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    } success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
        showFadeOutText(@"发送成功", 0, 3);
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:kWindow animated:YES];
    }];
}

- (void)getCategory {
    [NetWorkManager NetworkPOST:@"dictionary/getall" parameters:nil startHander:^{
    } success:^(NSDictionary *result) {
        NSMutableArray *dataArr = [CategoryDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"][@"category"]];
        [self.categoryArr addObjectsFromArray:dataArr];
        
        self.items = [[NSMutableArray alloc] init];
        NSInteger i = 0;
        for (CategoryDTO *item in self.categoryArr) {
            XYMenuItem *model = [XYMenuItem menuItem:item.dictionaryName image:nil tag:i userInfo:@{@"title":@"Menu"}];
            [self.items addObject:model];
            i++;
        }
        
        NSMutableArray *levelArr = [CategoryDTO mj_objectArrayWithKeyValuesArray:result[@"resultdata"][@"notice"]];
        [self.emergencyArr addObjectsFromArray:levelArr];
        self.levelItems = [[NSMutableArray alloc] init];
        NSInteger j = 0;
        for (CategoryDTO *item in self.emergencyArr) {
            XYMenuItem *model = [XYMenuItem menuItem:item.dictionaryName image:nil tag:i userInfo:@{@"title":@"Menu"}];
            [self.levelItems addObject:model];
            j++;
        }
        
    } failed:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (DatePickerView *)dateView {
    if (!_dateView) {
//        __weak __typeof(self)weakSelf = self;
        _dateView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, kScreenWidth, 260)];
    }
    return _dateView;
}

@end
