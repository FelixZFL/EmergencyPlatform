//
//  JuImageItemCVCell.h
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Screen_Width        [[UIScreen mainScreen] bounds].size.width
#define SHItemSize ((Screen_Width-44)/3)

typedef void(^juHandle)(id image);             //下步操作后有跟新数据
@interface JuImageItemCVCell : UICollectionViewCell{
    
    __weak IBOutlet UIButton *ju_btnDelete;
    __weak IBOutlet UIImageView *ju_imageView;
    __weak IBOutlet UIButton *ju_btnAdd;
}
@property (nonatomic,copy  ) juHandle ju_handle;
-(void)juSetCollentImage:(id)image;
-(void)juIsAddImage:(BOOL)isAdd;
-(void)juSetUrlImage:(NSString *)urlName;
@end
