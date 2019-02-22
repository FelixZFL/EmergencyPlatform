//
//  MDImageCache.m
//  meimeidou
//
//  Created by william on 13-11-30.
//  Copyright (c) 2013年 meimeidou. All rights reserved.
//

#import "MDImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MDImageCache

// md5加密
+ (NSString *) md5HexDigest:(NSString *)str
{
  const char *original_str = [str UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(original_str, (int)strlen(original_str), result);
  NSMutableString *hash = [NSMutableString string];
  for (int i = 0; i < 16; i++)
    [hash appendFormat:@"%02X", result[i]];
  return [hash lowercaseString];
}

+ (NSData*) getImage:(NSString*) url
{
  NSString *tmpDir = [MDImageCache getImageCacheFolder];
  NSString* md5 = [MDImageCache md5HexDigest:url];
  NSString* file = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", md5]];
  //NSLog(@"%@", file);
  
  NSData* image;
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
    // 取得文件
    image = [[NSFileManager defaultManager]contentsAtPath:file];
  } else {
    image = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    [[NSFileManager defaultManager] createFileAtPath:file contents:image attributes:nil];
  }
  
  return image;
}

+ (NSString *)getImageCacheFolder
{
  NSString* tmpDir = NSTemporaryDirectory();
  NSString* cacheDir = [tmpDir stringByAppendingPathComponent:@"ImageCache"];
  BOOL isExists = [[NSFileManager defaultManager]fileExistsAtPath:cacheDir];
  if (!isExists) {
    [[NSFileManager defaultManager]createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
  }
  return cacheDir;
}

+ (void)clearImageCache
{
  NSString* tmpDir = NSTemporaryDirectory();
  NSString* cacheDir = [tmpDir stringByAppendingPathComponent:@"ImageCache"];
  BOOL isExists = [[NSFileManager defaultManager]fileExistsAtPath:cacheDir];
  if (isExists) {
    [[NSFileManager defaultManager]removeItemAtPath:cacheDir error:nil];
  }
}

@end
