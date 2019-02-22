//
//  SystemHelper.m
//  alaxiaoyou
//
//  Created by MoDeguang on 16/1/10.
//  Copyright © 2016年 MoDeguang. All rights reserved.
//

#import "SystemHelper.h"

@implementation SystemHelper
//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope
{
    //    UIImage *image = nil;
    //    CGSize size = origImage.size;
    //
    //    if (size.width < scope && size.height < scope) {
    //        // do nothing
    //        image = origImage;
    //    } else {
    //        CGFloat length = size.width;
    //        if (size.width < size.height) {
    //            length = size.height;
    //        }
    //
    //     CGFloat f = scope/length;
    //     NSInteger nw = size.width * f;
    //     NSInteger nh = size.height * f;
    //
    //    if (nw > scope) {
    //        nw = scope;
    //    }
    //    if (nh > scope) {
    //        nh = scope;
    //    }
    //    CGFloat length = size.width;
    //    NSInteger nw;
    //    NSInteger nh;
    //    if (size.width > scope) {
    //        CGFloat f = scope/length;
    //        nw = size.width * f;
    //        nh = size.height * f;
    //
    //    }else {
    //
    //        nw = size.width;
    //        nh = size.height;
    //
    //    }
    //
    //        CGSize newSize = CGSizeMake(nw, nh);
    //        CGSize newSize = CGSizeMake(size.width*f, size.height*f);
    //
    //
    //        if ([[UIScreen mainScreen] scale] == 2.0) {
    //            UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    //        }else {
    //
    //            UIGraphicsBeginImageContext(newSize);
    //        }
    //        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    //        // Tell the old image to draw in this new context, with the desired new size
    //        [origImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    //        // Get the new image from the context
    //        image = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //    UIImage *img = [SystemHelper pressImage:image coefficient:0.1];
    //    }
    //    return origImage;
    //    return img;
    
    UIImage *image = nil;
    CGSize size = origImage.size;
    if (size.width < scope && size.height < scope) {
        // do nothing
        image = origImage;
    } else {
        CGFloat length = size.width;
        if (size.width < size.height) {
            length = size.height;
        }
        CGFloat f = scope/length;
        NSInteger nw = size.width * f;
        NSInteger nh = size.height * f;
        
        CGSize newSize = CGSizeMake(nw, nh);
        UIGraphicsBeginImageContext(newSize);
        //UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [origImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        // Get the new image from the context
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}
@end
