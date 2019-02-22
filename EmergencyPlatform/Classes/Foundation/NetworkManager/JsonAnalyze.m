//
//  JsonAnalyze.m
//  AudioJack
//
//  Created by Ai-Care on 11/16/13.
//  Copyright (c) 2013 Chen Jack. All rights reserved.
//

#import "JsonAnalyze.h"

@implementation JsonAnalyze

//解析JSON数据
+(NSDictionary *)analyze:(NSString*)json
{
    NSString *jsonString = [NSString stringWithString:json];
    NSData *jasonData = [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //JSON parser
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableLeaves error:nil];
    return jsonDic;
}

+(NSArray *)analyzeToArray:(NSString*)json
{
    NSString *jsonString = [NSString stringWithString:json];
    NSData *jasonData = [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //JSON parser
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableLeaves error:nil];
    return jsonArray;
}

@end
