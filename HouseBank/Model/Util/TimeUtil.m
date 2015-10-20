//
//  TimeUtil.m
//  wasai
//
//  Created by apple on 14-3-25.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import "TimeUtil.h"
#import <Foundation/Foundation.h>


@implementation TimeUtil
+(NSString *) timeStrByDataAndFormat:(NSDate *)data format:(NSString *)timeFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeFormat];
    NSString *time = [formatter stringFromDate:data];
    return time;
}

+(NSString *) nowTimeStrByFormat:(NSString *)timeFormat{
    return [self timeStrByDataAndFormat:[NSDate date]  format:timeFormat];
}

+(NSString *) nowTimeStrWithDefault{
    return [self nowTimeStrByFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+(long) msFrom1970{
    return [[NSDate date] timeIntervalSince1970];
}

+(NSDate *) timeWithFormat2Data:(NSString *)timeStr format:(NSString *)timeFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    if (timeFormat) {
        [formatter setDateFormat:timeFormat];
    }
    return [formatter dateFromString:timeStr];
}

+(NSString *) timeStrByDataWithDefault:(NSDate *)data{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:data];
}

+(NSString *) timeStrFromFormat2OtherFormat:(NSString *)timeStr originalFormat:(NSString *)format targetFormat:(NSString *)targetFormat{
    NSDate *date = [self timeWithFormat2Data:timeStr format:format];
    return [self timeStrByDataAndFormat:date format:targetFormat];
}

+(NSString *) timeOfterWithMonth : (NSInteger) month{
    double timeOfter = month*24*60*60*30;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeOfter];
    return [self timeStrByDataAndFormat:date format:@"yyyy-MM-dd"];
};

@end
