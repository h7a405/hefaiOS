//
//  NSString+Helper.m
//
//
//  Created by 鹰眼 on 13-11-28.
//  Copyright (c) 2013年 QCloud. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (self.length == 0);
}

#pragma mark 返回沙盒中的文件路径
- (NSString *)documentsPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingString:self];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize;
}
@end
