//
//  MDImageCache.h
//  meimeidou
//
//  Created by william on 13-11-30.
//  Copyright (c) 2013年 meimeidou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDImageCache : NSObject

+ (NSString *) md5HexDigest:(NSString *)str;

+ (NSData*) getImage:(NSString*) url;

+ (void)clearImageCache;

@end
