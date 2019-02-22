//
//  ReportContentCell.m
//  EmergencyPlatform
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ReportContentCell.h"
#import "XYAudioPlayer.h"

#import "noteReportimg.h"

#define kItemSize  (kScreenWidth-30)/3.0
@implementation ReportContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.photosView addSubview:self.flowPhotosView];
    [self.flowPhotosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photosView);
    }];
}

//创建一个流水布局photosView(默认为流水布局)
- (PYPhotosView *)flowPhotosView{
    if (!_flowPhotosView) {
        _flowPhotosView = [PYPhotosView photosView];
        //图片状态已发布
        _flowPhotosView.photosState = PYPhotosViewStateDidCompose;
        //设置分页指示类型
        _flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    }
    return _flowPhotosView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWith:(ReportMesDTO *)data {
    _name.text = data.user.userName;
    _reportTime.text = data.reportTime;
    _content.text = data.content;
    
    //修复高度
    CGSize size = [_content sizeThatFits:CGSizeMake(kScreenWidth-20, MAXFLOAT)];
    if (size.height <= 14) {
        _heightConstraint.constant = 14;
    } else {
        _heightConstraint.constant = size.height;
    }
    
    if (IsStrEmpty(data.avi)) {
        _bgHeightCons.constant = 0;
    } else {
        _bgHeightCons.constant = 50;
    }
    
    _photosArray = [[NSMutableArray alloc] init];
    
    for (noteReportimg *item in data.noteReportimg) {
        if (IsStrEmpty(item.img)) {
            _photosViewHit.constant = 0;
            return;
        }
        [_photosArray addObject:item.img];
    }
    //图片
    if (_photosArray.count > 0) {
        //设置缩略图数组
        self.flowPhotosView.thumbnailUrls = _photosArray;
        //设置原图地址
        self.flowPhotosView.originalUrls = _photosArray;
        //设置图片尺寸
        self.flowPhotosView.photoWidth = kItemSize;
        self.flowPhotosView.photoHeight = kItemSize;
        //调整图片视图高度
        if (_photosArray.count < 4) {
            _photosViewHit.constant = kItemSize;
        }else if (_photosArray.count < 7) {
            _photosViewHit.constant = kItemSize * 2 + 5;
        }else {
            _photosViewHit.constant = kScreenWidth-20;
        }
    } else {
        _photosViewHit.constant = 0;
    }
    [self layoutIfNeeded];
}
@end
