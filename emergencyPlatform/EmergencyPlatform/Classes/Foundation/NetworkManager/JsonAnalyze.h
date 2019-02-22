//
//  JsonAnalyze.h
//  AudioJack
//
//  Created by Ai-Care on 11/16/13.
//  Copyright (c) 2013 Chen Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonAnalyze : NSObject

+(NSDictionary *)analyze:(NSString*)json;
+(NSArray *)analyzeToArray:(NSString*)json;

@end
