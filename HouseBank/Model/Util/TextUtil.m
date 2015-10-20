//
//  TextUtil.m
//  wasai
//
//  Created by apple on 14-3-21.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <objc/runtime.h>
#import "TextUtil.h"

@implementation TextUtil

+(void) logObject:(id)obj{
    NSUInteger outCount = 0;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for( int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const  char *c = property_getName(property);
        NSString *key = [NSString stringWithUTF8String : c];
        NSString *value = [obj valueForKey:key];
        NSLog(@"%@ = %@",key,value);
    }
    NSLog(@"--------------------");
    free(properties);
}

+(BOOL) isEmpty:(NSString *)str{
    NSString *empty = @"";
    if ( nil == str || [empty isEqualToString:str] || [[str class] isKindOfClass: [[NSNull null] class]]) {
        return true;
    }
    return false;
}

+(NSString *) stringUUID{
    NSUUID *uuid = [NSUUID UUID];
    NSString *str =  [[uuid UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

+(NSString *) sqliteEscape : (NSString *)keyWord{
    NSString *replaceStr =[[keyWord copy] autorelease];
    //    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    return replaceStr;
}

+(CGSize)sizeWithContent:(UILabel *)content{
    UIFont * tfont = content.font;
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    CGSize  actualsize =[content.text boundingRectWithSize:CGSizeMake(content.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize;
}

+(CGSize)sizeWithContent:(UILabel *)content maxSize:(CGSize)size{
    UIFont * tfont = content.font;
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    CGSize  actualsize =[content.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize;
}

//是否为整形
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (NSString *) replaceNull : (NSString *) str{
    if ([self isEmpty:str] || [str isKindOfClass: [[NSNull null] class]]) {
        return @"";
    }
    return str;
};

+ (BOOL) isNumbel : (NSString *) string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
};

@end
