//
//  UIView+Extension.h
//  ainonggu
//
//  Created by zfl－mac on 2018/8/19.
//  Copyright © 2018年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;


- (UIViewController*)viewController;
- (UINavigationController *)navigationController;



@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

- (void)setCorner:(CGFloat)corner;
- (void)setDefaultCorner;

- (void)setborderColor:(UIColor *)color borderWidth:(CGFloat )width;
- (void)setborderColor:(UIColor *)color;

//- (MBProgressHUD *)showHUD:(NSString *)text;
//
//- (MBProgressHUD *)showLoadingHUD;


//阴影
-(void)setLayerShadowTop;
-(void)setLayerShadowBot;
- (void)setLayerShadowBot:(CGFloat)offset opacity:(CGFloat)opacity color:(UIColor *)color radius:(CGFloat)radius;
- (void)setLayerShadowOffset:(CGSize )offset opacity:(CGFloat)opacity color:(UIColor *)color radius:(CGFloat)radius;
- (void)setLayerShadowOffset:(CGSize )offset opacity:(CGFloat)opacity color:(UIColor *)color radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius;

@end
