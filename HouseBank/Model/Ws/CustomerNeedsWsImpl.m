//
//  CustomerNeedsWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CustomerNeedsWsImpl.h"

@implementation CustomerNeedsWsImpl

//请求客需
-(AFHTTPRequestOperationManager *) requestCustomerNeeds : (NSString*) sid pageNo : (NSInteger) pageNo communityId : (NSString *) communityId result : (Result) result{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    //    [param setObject:sid forKey:@"sid"];
    [param setObject:communityId forKey:@"communityId"];
    
    return [super doGet:KUrlConfig method:@"requirement" params:param result:result];
};

//搜索客需
-(AFHTTPRequestOperationManager *) searchCustomerNeeds : (NSString *) kw pageSize : (NSString *) pageSizeresult : (Result) result{
    NSDictionary *dict=@{@"kw": kw,
                         @"pageSize":@"20"
                         };
    return [super doGet:KUrlConfig method:@"community" params:dict result:result];
};

//条件查找客需
-(AFHTTPRequestOperationManager *) requestCustomerNeedsWithFilter : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom:(NSString *) areaFrom areaTo : (NSString *) areaTo bedRoom : (NSString *) bedRoom communityId : (NSString *) communityId purpose : (NSString *) purpose tradeType:(NSInteger) tradeType pageNo : (NSInteger) pageNo sid : (NSString *) sid result : (Result) result{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:regionId forKey:@"regionId"];
    [param setObject:priceFrom forKey:@"priceFrom"];
    [param setObject:priceTo forKey:@"priceTo"];
    [param setObject:areaFrom forKey:@"areaFrom"];
    [param setObject:areaTo forKey:@"areaTo"];
    [param setObject:bedRoom forKey:@"bedRoom"];
    [param setObject:communityId forKey:@"communityId"];
    [param setObject:purpose forKey:@"purpose"];
    [param setObject:@(tradeType) forKey:@"tradeType"];
    [param setObject:@(pageNo) forKey:@"pageNo"];
    [param setObject:sid forKey:@"sid"];
    
    return [super doGet:KUrlConfig method:@"requirement" params:param result:result];
};

//请求客需详情
-(AFHTTPRequestOperationManager *) requestCustomerNeedsDetail : (NSString *)requirement result : (Result) result{
    return [super doGet:KUrlConfig method:[NSString stringWithFormat:@"requirement/%@",requirement] params:nil result:result];
};


@end
