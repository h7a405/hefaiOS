//
//  SubscibeWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface SubscibeWsImpl : BaseWs

//提交订阅
-(AFHTTPRequestOperationManager *) submitSubscibe : (NSString *) sid contentType : (NSString *) contentType target : (NSString *) target regionId : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo tradeType : (NSInteger) tradeType purpose : (NSString *) purpose result : (Result) result;

//请求订阅
-(AFHTTPRequestOperationManager *) requestSubscibe : (NSString *) sid contentType : (NSString *) contentType tradeType : (NSInteger) tradeType result : (Result) result;

//请求订阅信息
-(AFHTTPRequestOperationManager *) requestSubscibeInfo : (NSString *) sid contentType : (NSString *) contentType tradeType : (NSInteger) tradeType result : (Result) result;

//订阅房源列表
-(AFHTTPRequestOperationManager *) requestSubscriptionHouseList : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo sort : (NSInteger) sort sid : (NSString*) sid result : (Result) result;

@end
