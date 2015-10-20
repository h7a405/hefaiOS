//
//  CustomerNeedsWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface CustomerNeedsWsImpl : BaseWs

//请求客需
-(AFHTTPRequestOperationManager *) requestCustomerNeeds : (NSString*) sid pageNo : (NSInteger) pageNo communityId : (NSString *) communityId result : (Result) result;

//搜索客需
-(AFHTTPRequestOperationManager *) searchCustomerNeeds : (NSString *) kw pageSize : (NSString *) pageSizeresult : (Result) result;

//条件查找客需
-(AFHTTPRequestOperationManager *) requestCustomerNeedsWithFilter : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo bedRoom : (NSString *) bedRoom communityId : (NSString *) communityId purpose : (NSString *) purpose tradeType:(NSInteger) tradeType pageNo : (NSInteger) pageNo sid : (NSString *) sid result : (Result) result;

//请求客需详情
-(AFHTTPRequestOperationManager *) requestCustomerNeedsDetail : (NSString *)requirement result : (Result) result;

@end
