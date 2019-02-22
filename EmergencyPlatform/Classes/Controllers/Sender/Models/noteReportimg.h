//
//  noteReportimg.h
//  EmergencyPlatform
//
//  Created by nick chen on 2018/7/24.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseDataModel.h"

@interface noteReportimg : BaseDataModel

@property (copy, nonatomic) NSString *noteReportImgID;
@property (copy, nonatomic) NSString *noticeReportID;
@property (nonatomic) NSInteger isDelete;
@property (copy, nonatomic) NSString *img;
@property (nonatomic) NSInteger sort;
@property (copy, nonatomic) NSString *noticeID;

@end
