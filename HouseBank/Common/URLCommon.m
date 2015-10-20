//
//  ImageURLCommon.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "URLCommon.h"

@implementation URLCommon
+(NSString *) buildImageUrl:(NSString *) imagePath imageSize : (ImageSize) imageSize brokerId:(NSNumber *)brokerId{
    //每次调用根据brokerId随机从3个图片域名中选择一个,使域名分散使用并且所有域名的使用几率近乎相同
    NSString *url = [NSString stringWithFormat:@"%@%@%@",ImgBaseUrl([brokerId intValue]%ImageServerNum),imagePath,ImageSizeStr(imageSize)];
    return url;
}

+(NSString *) buildImageUrl:(NSString *) imagePath imageSize : (ImageSize) imageSize{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",ImgBaseUrl(1),imagePath,ImageSizeStr(imageSize)];
    return url;
};

+(NSString *) buildUrl : (NSString *) resource{
    return [NSString stringWithFormat:@"%@%@",KUrlConfig,resource];
};

+(NSString *) buildUrl:(NSString *)resource resourceId : (id) resourceId{
    return [NSString stringWithFormat:@"%@%@/%@",KUrlConfig,resource,resourceId];
};

@end
