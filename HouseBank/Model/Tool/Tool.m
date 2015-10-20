//
//  Commom.m
//  GongChuang
//
//  Created by 鹰眼 on 14-8-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "Tool.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "CallRecords.h"
#import "FYUserDao.h"
#import "NSDictionary+String.h"

#define KSearchHistoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/history.plist"]
#define KUpdateAddressKey @"UpdataAddressKey"

@implementation Tool

/**
 *  打开数据库
 */
+(instancetype)openDB
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docs[0] stringByAppendingPathComponent:@"data.db"];
        
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        if (error) {
            NSLog(@"打开数据库出错 - %@", error.localizedDescription);
        } else {
            sharedInstance=[[NSManagedObjectContext alloc] init];
            [sharedInstance setPersistentStoreCoordinator:store];
        }
    });
    
    return sharedInstance;
}

+(NSURL *)baseUrl{
    NSURL *url=[NSURL URLWithString:KUrlConfig];
    return url;
}

+(NSURL *)imageUrlWithPath:(NSString *)path andTypeString:(NSString *)type
{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@!%@",KImageUrlConfig,path,type];
    return [NSURL URLWithString:urlStr];
}

+(NSAttributedString *)testcontent:(NSString *)content colorString:(NSArray *)searchs{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    if (searchs) {
        [searchs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSRange range=[content rangeOfString:obj];
            NSInteger location=0;
            while (range.length>0) {
                [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location+range.location, range.length)];
                location+=(range.location+range.length);
                NSString *tmp= [content substringWithRange:NSMakeRange(range.location+range.length, content.length-location)];
                range=[tmp rangeOfString:obj];
            }
            
        }];
    }
    
    return attString;
}

+(NSString *)towartWithTypeString:(NSString *)type{
    NSInteger typeIndex=[type integerValue];
    switch (typeIndex) {
        case 1:
            return @"东";
        case 2:
            return @"南";
        case 3:
            return @"西";
        case 4:
            return @"北";
        case 5:
            return @"南北";
        case 6:
            return @"东西";
        case 7:
            return @"东南";
        case 8:
            return @"西南";
        case 9:
            return @"东北";
        case 10:
            return @"西北";
        case 11:
            return @"不知道朝向";
            
            
    }
    
    return @"";
    
}
+(NSString *)decorationStateWithType:(NSString *)type
{
    switch ([type integerValue]) {
        case 1:
            return @"毛胚";
        case 2:
            return @"简装";
        case 3:
            return @"精装";
        case 4:
            return @"豪装";
        case 5:
            return @"中装";
    }
    return @"";
}

+(NSString *)stringWithHtml:(NSString *)html{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    return attrString.string;
    
}
+(NSString *)authStatus:(NSString *)status
{
    switch ([status integerValue]) {
        case 1:
            return @"未认证";
        case 2:
            return @"认证中";
        case 3:
            return @"已认证";
        case 4:
            return @"认证未通过";
            
    }
    return @"未知";
}
+(NSString *)cooperationStatus:(NSString *)status
{
    switch ([status integerValue]) {
        case 1:
            return @"申请中";
        case 2:
            return @"接受";
        case 3:
            return @"拒绝";
        case 4:
            return @"已完成";
        case 5:
            return @"未成交";
            
    }
    return @"未知";
}
+(NSString *)purpose:(NSString *)purpose
{
    switch ([purpose integerValue]) {
        case 1:
            return @"住宅";
        case 2:
            return @"写字楼";
        case 3:
            return @"商铺";
    }
    return @"未知";
}

+(NSString *)tradeType:(NSString *)tradeType
{
    switch ([tradeType integerValue]) {
        case 1:
            return @"求售";
        case 2:
            return @"求租";
    }
    return @"未知";
}


+(NSString *)decorationState:(NSString *)state
{
    if([state isEqualToString:@"0"])return @"不限";
    __block NSMutableString *string=[NSMutableString string];
    NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DecorationState" withExtension:@"plist"]];
    
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendString: [Tool typeWithValue:state index:[key integerValue]-1 content:obj]];
            
        }];
    }];
    return [string substringToIndex:string.length-1];
}
+(NSString *)toward:(NSString *)state
{
    if([state isEqualToString:@"0"])return @"不限";
    __block NSMutableString *string=[NSMutableString string];
    NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Toward" withExtension:@"plist"]];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendString: [Tool typeWithValue:state index:[key integerValue] content:obj]];
        }];
    }];
    return [string substringToIndex:string.length-1];
}
+(NSString *)houseType:(NSString *)state type:(NSString *)type
{
    if([state isEqualToString:@"0"])return @"不限";
    __block NSMutableString *string=[NSMutableString string];
    NSArray *all=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HouseType" withExtension:@"plist"]];
    NSArray *data=nil;
    if ([type integerValue]<3) {
        data=[all firstObject];
    }else{
        data=[all lastObject];
    }
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendString: [Tool typeWithValue:state index:[key integerValue] content:obj]];
        }];
    }];
    
    return [string substringToIndex:string.length-1];
}

+(NSString *)bedroom:(NSString *)state
{
    if([state isEqualToString:@"0"])return @"不限";
    __block NSMutableString *string=[NSMutableString string];
    NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Bedroom" withExtension:@"plist"]];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendString: [Tool typeWithValue:state index:[key integerValue]-1 content:obj]];
        }];
    }];
    return [string substringToIndex:string.length-1];
}
/**
 *  检测枚举
 *
 *  @param value   后台返回值
 *  @param index   对应状态码
 *  @param content 状态内容
 *
 *  @return
 */
+(NSString *)typeWithValue:(NSString *)value index:(NSInteger)index content:(NSString *)content
{
    NSInteger tmp=[value integerValue];
    
    if (((int)(pow(2, index))&tmp)==(int)pow(2, index)) {
        return [NSString stringWithFormat:@"%@,",content];
    }
    return @"";
}

+(void)callPhone:(NSString *)phone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,184,187,188,147,178
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2-478]|47|78)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,145,176
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|45|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,177,181
     22         */
    NSString * CT = @"^1((33|53|8[019]|77})[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString *PHONENUMBER = @"(^(\\d{3,4}-)?\\d{7,8})$|(1[3|5|7|8|][0-9]{9})";
    
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONENUMBER];
    if(![regextestPhone evaluateWithObject:mobileNum]){
        return NO;
    }
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)validateLengthWithString:(NSString *)string andType:(NSInteger)type{
    switch (type) {
        case textTypePhoneNumber:
            if(string.length == 11)
                return YES;
            break;
        case textTypeValidateNumber:
            if(string.length == 6)
                return YES;
            break;
        case textTypePassword:
            if(string.length >= 4 && string.length <= 18)
                return YES;
            break;
        case textTypeName:
            if(string.length > 0)
                return YES;
            break;
        case textTypeAddress:
            if(string.length > 0)
                return YES;
            break;
        case textTypeIDNumber:
            if(string.length == 18 || string.length == 15)
                return YES;
            break;
        case textTypeCode:
            if(string.length == 8)
                return YES;
            break;
        case textTypeStock:
            if(string.length > 0)
                return YES;
            break;
        default:
            return NO;
            break;
    }
    return NO;
}

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

//获取时间戳时间格式字符串
+ (NSString *)getDateStringWithDate:(long long)timestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date_timestamp = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
//    NSLog(@"%s || timestamp:%lld to NSDate:%@", __FUNCTION__, timestamp, date_timestamp);
    NSString *string_timestamp = [formatter stringFromDate:date_timestamp];
//    NSLog(@"%s || NSDate:%@ to NSString:%@", __FUNCTION__, date_timestamp, string_timestamp);
    return string_timestamp;
}

+ (NSString *)getUserCharacterWithInt:(int)character{
    NSString *string_character;
    switch (character) {
        case FYMEMBER:
            string_character = @"会员";
            break;
        case FYBROKER:
            string_character = @"经纪人";
            break;
        case FYBANKER:
            string_character = @"行长";
            break;
        case FYHOLDER:
            string_character = @"股权人";
            break;
        default:
            string_character = @"未知";
            break;
    }
    return string_character;
}

@end
