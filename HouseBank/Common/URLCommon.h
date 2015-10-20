//
//  URLCommon.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

/**
 该类用于产生服务器请求的url，包括图片请求。
 */

#import <Foundation/Foundation.h>

#ifndef HouseBank_ImageURLCommon_h
#define HouseBank_ImageURLCommon_h
/**
 图片加载域名，一共有三个，x从0~2
 */
#define ImgBaseUrl(x) [NSString stringWithFormat:@"http://img%d.fybanks.com",x]
#define ImageServerNum 3 //图片域名个数
#define RanromIndex arc4random() % ImageServerNum
//各个图片大小对应的参数
#define ImageSizeStrs [NSArray arrayWithObjects:@"!L01",@"!L02",@"!L03",@"!L04",@"!D01",@"!D02",@"!D03",@"!D04",@"!B01",@"!A01",nil]
#define ImageSizeStr(x) [ImageSizeStrs objectAtIndex:x]
#endif

typedef NS_OPTIONS(NSUInteger, ImageSize) {
    L01 = 0,
    L02 = 1,
    L03 = 2,
    L04 = 3,
    D01 = 4,
    D02 = 5,
    D03 = 6,
    D04 = 7,
    B01 = 8,
    A01 = 9
};


@interface URLCommon : NSObject

+(NSString *) buildImageUrl:(NSString *) imagePath imageSize : (ImageSize) imageSize brokerId : (NSNumber *) brokerId;
+(NSString *) buildImageUrl:(NSString *) imagePath imageSize : (ImageSize) imageSize;
+(NSString *) buildUrl : (NSString *) resource;
+(NSString *) buildUrl:(NSString *)resource resourceId : (id) resourceId;

@end
