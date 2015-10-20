//
//  TextUtil.h
//  wasai
//
//  Created by apple on 14-3-21.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 该类是对字符串操作的一些工具方法，该类的所有方法都是类方法，无需实例化该类。
 **/

@interface TextUtil : NSObject

/**
 判断一个字符串是否为空，判断的标准是该字符串长度为0，或者该字符串没有实例。
 如果为空返回true，否则返回false
 */
+(BOOL) isEmpty: (NSString *) str;

/**
 获取一个uuid，该操作去掉了4个“-”,所以只有32位
 */
+(NSString *) stringUUID;

/**
 打印实体类的key和相应的key的值，该方法仅做调试用。
 */
+(void) logObject : (id)obj;

/**
 将数据存进sqlite可能的出现的错误字符进行替换
 */
+(NSString *) sqliteEscape : (NSString *)keyWord;

/**
 *  计算字符串大小
 *
 *  @param content
 *
 *  @return
 */
+(CGSize)sizeWithContent:(UILabel *)content;

/**
 *  固定大小计算字符串大小
 *
 *  @param content
 *  @param size
 *
 *  @return
 */
+(CGSize)sizeWithContent:(UILabel *)content maxSize:(CGSize)size;

+ (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

+ (NSString *) replaceNull : (NSString *) str;

+ (BOOL) isNumbel : (NSString *) str ;

@end
