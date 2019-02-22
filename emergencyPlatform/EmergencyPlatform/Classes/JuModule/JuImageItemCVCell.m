//
//  JuImageItemCVCell.m
//  EmergencyPlatform
//
//  Created by Juvid on 2018/7/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JuImageItemCVCell.h"
#import <UIImageView+WebCache.h>
@implementation JuImageItemCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)juSetCollentImage:(id)image{
    ju_imageView.image=image;
}

-(void)juSetUrlImage:(NSString *)urlName{
    ju_btnAdd.hidden=YES;
    ju_btnDelete.hidden=YES;
    [ju_imageView sd_setImageWithURL:[NSURL URLWithString:urlName]];
}
-(void)juIsAddImage:(BOOL)isAdd{
    if (isAdd) {
        ju_imageView.image=nil;
    }
    ju_btnAdd.hidden=!isAdd;
    ju_btnDelete.hidden=isAdd;
}
- (IBAction)JuTouchDeleteImage:(UIButton *)sender {
    if (self.ju_handle) {
        self.ju_handle(ju_imageView.image);
    }
}

@end
