//
//  TimeUtil.h
//  wasai
//
//  Created by apple on 14-3-25.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

/**
 根据data获取指定格式的时间字符串
 */
+(NSString *) timeStrByDataAndFormat:(NSDate *) data format : (NSString *)timeFormat;

/**
 获取指定格式的当前时间字符串
 */
+(NSString *) nowTimeStrByFormat : (NSString *)timeFormat;

/**
 获取默认格式的当前时间字符串，默认格式为yyyy-MM-dd HH:mm:ss
 */
+(NSString *) nowTimeStrWithDefault ;

/**
 获取从1970到当前时间的毫秒，为一个long数值
 */
+(long) msFrom1970;

/**
 根据一个有时间格式的字符串获取一个日期类
 */
+(NSDate *) timeWithFormat2Data : (NSString *) timeStr format : (NSString *) timeFormat;

/**
 根据一个data类获取默认格式的时间字符串，默认格式为yyyy-MM-dd HH:mm:ss
 */
+(NSString *) timeStrByDataWithDefault : (NSDate *) data;

+(NSString *) timeStrFromFormat2OtherFormat : (NSString *) timeStr originalFormat : (NSString *)format targetFormat : (NSString *) targetFormat;

+(NSString *) timeOfterWithMonth : (NSInteger) month;

@end
