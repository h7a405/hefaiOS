//
//  NewHouseWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NewHouseWsImpl.h"

@implementation NewHouseWsImpl

//请求新房数据
-(AFHTTPRequestOperationManager *) requestNewHouse : (NSInteger) pageNo pageSize : (NSInteger) pageSize result : (Result) result {
    NSDictionary *dict=@{@"pageNo":[NSString stringWithFormat:@"%d",pageNo],@"pageSize":[NSString stringWithFormat:@"%d",pageSize]};
    return [super doGet:KUrlConfig method:RESOURCE_NEW_HOUSE params:dict result:result];
};

//请求新房信息
-(AFHTTPRequestOperationManager *) requestHouseInfo : (NSString *) projectId result : (Result) result{
    return [super doGet:KUrlConfig method:[NSString stringWithFormat:@"newhouse/%@",projectId]  params:nil result:result];
};

//请求新房房型
-(AFHTTPRequestOperationManager *) requestHouseModel : (NSString *) communityId result : (Result) result{
    return [super doGet:KUrlConfig method:[NSString stringWithFormat:@"houseunit/%@",communityId] params:nil result:result];
};

-(AFHTTPRequestOperationManager *) submitOrder : (NSString *) sid projectId : (NSString *) projectId name : (NSString *) name phone : (NSString *) phone result : (Result) result {
    NSDictionary *dict=@{@"sid":sid,
                         @"projectId":projectId,
                         @"name":name,
                         @"phone":phone,
                         };
    return [super doPost:KUrlConfig method:RESOURCE_NEW_HOUSE_RESERVATION params:dict result:result];
};

//请求Award
-(AFHTTPRequestOperationManager *) requestAward : (NSString *) projectId result : (Result) result{
    return [super doGet:KUrlConfig method:[NSString stringWithFormat:@"new/house/info/%@",projectId]  params:nil result:result];
};

@end
