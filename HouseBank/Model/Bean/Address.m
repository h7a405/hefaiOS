//
//  Address.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-12.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "Address.h"
#import "FYAddressDao.h"

@implementation Address

@dynamic tid;
@dynamic name;
@dynamic pinyin;
@dynamic py;
@dynamic sort;

+(NSArray *)getAllProvience{
    return [[FYAddressDao new] allProvience ];
}

+(NSArray *)citysWithProvience:(Address *)provience{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",provience.tid]];
}
+(NSArray *)areasWithCity:(Address *)city{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",city.tid]];
}
+(NSArray *)streesWithArea:(Address *)area{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",area.tid]];
}

+(NSArray *)addressDataWithPid:(NSString *)pid{
    return [[FYAddressDao new] addressDataWithPid:pid];
}

+(NSArray *)addressByAId : (id) aid{
    return [[FYAddressDao new] addressByAId:aid];;
};

+(NSArray *)allCity{
    return [[FYAddressDao new] allCity];
}

+(NSString *)addressWithRegionId:(NSString *)regionId{
    return [[FYAddressDao new] addressWithRegionId:regionId];
}

+(NSString *)addressIdWithCityName:(NSString *)name{
    return [[FYAddressDao new] addressIdWithCityName:name];
}

@end
