//
//  Commom.h
//  GongChuang
//
//  Created by 鹰眼 on 14-8-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  此为工具类

#import <Foundation/Foundation.h>
@interface Tool : NSObject
/**
 *  房源类型
 */
typedef NS_ENUM(NSInteger, HouseType){
    /**
     *  二手房
     */
    HouseTypeSell=0,
    /**
     *  出租房
     */
    HouseTypeRent=1
};
/**
 *  客房类型,默认不可用
 */
typedef NS_ENUM(NSInteger,NeedType){
    /**
     *  求购
     */
    NeedTypeSell =1,
    /**
     *  求租
     */
    NeedTypeRent =2
};
/**
 *  房子使用类型
 */
typedef NS_ENUM(NSInteger, HouseUseType){
    /**
     *  默认，不限
     */
    HouseUseTypeDefault = 0,
    /**
     *  住房
     */
    HouseUseTypeLive = 1,
    
    /**
     *  写字楼
     */
    HouseUseTypeWork = 2,
    
    /**
     *  商铺
     */
    HouseUseTypeBusiness = 3,
    
    //厂房
    HouseUseTypeFactory = 4
};

typedef NS_ENUM(NSInteger, TextType){
    textTypePhoneNumber = 0,
    
    textTypeValidateNumber = 1,
    
    textTypePassword = 2,
    
    textTypeName = 3,
    
    textTypeAddress = 4,
    
    textTypeIDNumber = 5,
    
    textTypeCode = 6,
    
    textTypeStock = 7
};

typedef NS_ENUM(NSInteger, userCharacter) {
    FYMEMBER = 1,
    FYBROKER = 2,
    FYBANKER = 3,
    FYHOLDER = 4
};

/**
 *  打开数据库
 *
 *  @return 返回数据库上下文
 */
+(instancetype)openDB;


/**
 *  HTTP URL
 *
 *  @return
 */
+(NSURL *)baseUrl;

/**
 *  图片路径
 *
 *  @param path 拿到服务器返回的路径
 *  @param type 图片显示类型
 *
 *  @return url
 */
+(NSURL *)imageUrlWithPath:(NSString *)path andTypeString:(NSString *)type;

/**
 *  朝向
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)towartWithTypeString:(NSString *)type;

/**
 *  html->string
 *
 *  @param html
 *
 *  @return
 */
+(NSString *)stringWithHtml:(NSString *)html;

/**
 *  认证状态
 *
 *  @param status
 *
 *  @return
 */
+(NSString *)authStatus:(NSString *)status;

/**
 *  装修程度
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)decorationStateWithType:(NSString *)type;
/**
 *  拨打电话
 *
 *  @param phone
 */
+(void)callPhone:(NSString *)phone;

/**
 *  看房合作状态
 *
 *  @param status
 *
 *  @return
 */
+(NSString *)cooperationStatus:(NSString *)status;

/**
 *  艺术字处理
 *
 *  @param content
 *  @param searchs
 *
 *  @return
 */
+(NSAttributedString *)testcontent:(NSString *)content colorString:(NSArray *)searchs;

/**
 *  客需类型
 *
 *  @param purpose
 *
 *  @return
 */
+(NSString *)purpose:(NSString *)purpose;

/**
 *  客需类型
 *
 *  @param tradeTypep
 *
 *  @return
 */
+(NSString *)tradeType:(NSString *)tradeTypep;

/**
 *  客需装修
 *
 *  @param state
 *
 *  @return
 */
+(NSString *)decorationState:(NSString *)state;
/**
 *  客需朝向
 *
 *  @param state
 *
 *  @return
 */
+(NSString *)toward:(NSString *)state;

/**
 *  客需房子类型
 *
 *  @param state
 *  @param type  1，住房 2，写字楼 3，商铺
 *
 *  @return
 */
+(NSString *)houseType:(NSString *)state type:(NSString *)type;

/**
 *  验证手机
 *
 *  @param mobileNum
 *
 *  @return
 */

+(BOOL)validateMobile:(NSString *)mobileNum;

+ (BOOL)validateLengthWithString:(NSString *)string andType:(NSInteger)type;

+(NSString *)bedroom:(NSString *)state;

+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isPureFloat:(NSString*)string;

+ (NSString *)getDateStringWithDate:(long long)timestamp;
+ (NSString *)getUserCharacterWithInt:(int)character;

@end
