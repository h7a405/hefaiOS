//
//  SubscibeWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SubscibeWsImpl.h"

@implementation SubscibeWsImpl

//提交订阅
-(AFHTTPRequestOperationManager *) submitSubscibe : (NSString *) sid contentType : (NSString *) contentType target : (NSString *) target regionId : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo tradeType : (NSInteger) tradeType purpose : (NSString *) purpose result : (Result) result{
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:sid forKey:@"sid"];
    [param setObject:contentType forKey:@"contentType"];//1 房源  2客需
    [param setObject:target forKey:@"target"];//0所有 1 朋友
    [param setObject:regionId forKey:@"regionId"];
    
    [param setObject:priceFrom forKey:@"priceFrom"];
    [param setObject:priceTo forKey:@"priceTo"];
    
    [param setObject:areaFrom forKey:@"areaFrom"];
    [param setObject:areaTo forKey:@"areaTo"];
    [param setObject:@(tradeType) forKey:@"tradeType"];
    [param setObject:purpose forKey:@"purpose"];
    
    return [super doPost:KUrlConfig method:RESOURCE_SUBSCRIPTION params:param result:result];
};

//请求订阅
-(AFHTTPRequestOperationManager *) requestSubscibe : (NSString *) sid contentType : (NSString *) contentType tradeType : (NSInteger) tradeType result : (Result) result{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:sid forKey:@"sid"];
    [param setObject:contentType forKey:@"contentType"];//1 房源  2客需
    [param setObject:@(tradeType) forKey:@"tradeType"];//tradeType	int		T	交易类型(1:出售 2:出租 3:租售)
    
    return [super doGet:KUrlConfig method:RESOURCE_SUBSCRIPTION params:param result:result];
};

//请求订阅信息
-(AFHTTPRequestOperationManager *) requestSubscibeInfo : (NSString *) sid contentType : (NSString *) contentType tradeType : (NSInteger) tradeType result : (Result) result{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:sid forKey:@"sid"];
    [param setObject:contentType forKey:@"contentType"];//1 房源  2客需
    [param setObject:@(tradeType) forKey:@"tradeType"];//tradeType	int		T	交易类型(1:出售 2:出租 3:租售)
    return [super doGet:KUrlConfig method:RESOURCE_SUBSCRIPTION params:param result:result];
};

//订阅房源列表
-(AFHTTPRequestOperationManager *) requestSubscriptionHouseList : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo sort : (NSInteger) sort sid : (NSString*) sid result : (Result) result{
    NSDictionary *params = [NSDictionary dictionary];
    [params setValue:regionId forKey:@"regionId"];
    [params setValue:priceFrom forKey:@"priceFrom"];
    [params setValue:priceTo forKey:@"priceTo"];
    [params setValue:areaFrom forKey:@"areaFrom"];
    [params setValue:areaTo forKey:@"areaTo"];
    [params setValue:roomFrom forKey:@"roomFrom"];
    [params setValue:roomTo forKey:@"roomTo"];
    [params setValue:[NSString stringWithFormat:@"%d",sort] forKey:@"sort"];
    [params setValue:sid forKey:@"sid"];
    return [super doGet:KUrlConfig method:RESOURCE_SUBSCRIPTION_HOUSE params:params result:result];
};

@end
