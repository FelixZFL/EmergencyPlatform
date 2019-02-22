//
//  DNImagePickerController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/10.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsFilter;
FOUNDATION_EXTERN NSString *kDNImagePickerStoredGroupKey;
typedef NS_ENUM(NSUInteger, DNImagePickerFilterType) {
    DNImagePickerFilterTypeNone,
    DNImagePickerFilterTypePhotos,
    DNImagePickerFilterTypeVideos,
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromDNImagePickerControllerFilterType(DNImagePickerFilterType type);

@class DNImagePickerController;
@protocol DNImagePickerControllerDelegate <NSObject>
@optional
/**
 *  imagePickerController‘s seleted photos
 *
 *  @param imagePickerController
 *  @param imageAssets           the seleted photos packaged DNAsset type instances
 *  @param fullImage             if the value is yes, the seleted photos is full image
 */
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker
                     sendImages:(NSArray *)imageAssets
                    isFullImage:(BOOL)fullImage
                     imageArray:(NSArray *)imageArray;

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker;
@end
 

@interface DNImagePickerController : UINavigationController

@property (nonatomic, assign) DNImagePickerFilterType filterType;
@property (nonatomic, weak) id<DNImagePickerControllerDelegate> imagePickerDelegate;

//记录已选择图片张数
@property (nonatomic, assign) NSInteger picCount;
//选择图片张数限制
@property (nonatomic, assign) NSInteger selectMaxCount;

@end