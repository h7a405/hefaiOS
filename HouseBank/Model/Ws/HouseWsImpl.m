//
//  HouseWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseWsImpl.h"

@implementation HouseWsImpl

-(AFHTTPRequestOperationManager *) loadHouse : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo tradeType : (NSInteger) tradeType sort : (NSString *) sort pageNo : (NSInteger) pageNo kw : (NSString *) kw purpose : (NSInteger) purpose result : (void(^)(BOOL isSuccess , id result,NSString* data)) result {
    //    NSLog(@"priceFrom= %@ , priceTo= %@ , areaFrom= %@ , areaTo= %@ , roomFrom= %@ , roomTo= %@ , sort=  %@ , pageNo= %d , kw= %@ , regionId= %@ , tradeType= %d , purpose= %d",priceFrom,priceTo,areaFrom,areaTo,roomFrom,roomTo,sort,pageNo,kw,regionId,tradeType,purpose);
    
    NSDictionary *data=@{
                         @"regionId": [self replaceNilString:regionId],
                         @"priceFrom":[self replaceNilString:priceFrom],
                         @"priceTo": [self replaceNilString:priceTo],
                         @"areaFrom": [self replaceNilString:areaFrom],
                         @"areaTo": [self replaceNilString:areaTo],
                         @"roomFrom": [self replaceNilString:roomFrom],
                         @"roomTo": [self replaceNilString:roomTo],
                         @"tradeType":[NSString stringWithFormat:@"%d",tradeType],
                         @"sort": [self replaceNilString:sort],
                         @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],
                         @"kw":[self replaceNilString:kw],
                         @"purpose":[NSString stringWithFormat:@"%d",purpose]
                         };
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE params:data result:result];
};

-(AFHTTPRequestOperationManager *) loadHouseForSearch : (NSString *) kw pageSize : (NSString *) pageSize regionId : (NSString *) regionId result : (Result) result{
    NSDictionary *dict=@{@"kw": kw,
                         @"pageSize":pageSize,
                         @"regionId":regionId
                         };
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE_COMMUNITY params : dict result : result];
};

-(AFHTTPRequestOperationManager *) loadHouseInfoByHouseId : (NSString *) houseId sid : (NSString*) sid result : (Result) result{
    NSString *url=[NSString stringWithFormat:@"house/%@",houseId];
    return [super doGet:KUrlConfig method:url params:@{@"sid": [super replaceNilString:sid] } result:result];
};

-(AFHTTPRequestOperationManager *) loadCommunityInfoByCommunityId : (NSString *) communityId result : (Result) result{
    NSString *url=[NSString stringWithFormat:@"community/%@",communityId];
    return [super doGet:KUrlConfig method:url params:nil result:result];
};

//查询房子被查看次数
-(AFHTTPRequestOperationManager *) loadHouseCheckCount : (NSString *) houseId brokerId : (NSString *) brokerId result : (Result) result{
    NSDictionary *dict=@{@"pid": @"101",
                         @"rid": houseId,
                         @"uid": [super replaceNilString:brokerId],
                         @"sid": [super replaceNilString:brokerId]
                         };
    return [super doPost:KUrlConfig method:@"page/view"  params:dict result:result];
};

-(AFHTTPRequestOperationManager *) applyForCheckHouse : (NSString *) houseId brokerId : (NSString *) brokerId sid : (NSString *) sid result : (Result) result{
    NSDictionary *dict=@{
                         @"houseId":houseId,
                         @"brokerId":brokerId,
                         @"sid":sid,
                         };
    return [super doPost:KUrlConfig method:COOPERATION_HOUSE params:dict result:result];
};

//经纪人用户评价
-(AFHTTPRequestOperationManager *) brokerScore : (NSString *) brokerId pageNo : (NSInteger) pageNo pageSize : (NSInteger) pageSize targetBrokerId : (NSString *) targetBrokerId result : (Result) result {
    NSDictionary *dict=@{
                         @"brokerId":brokerId,
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"pageSize":[NSString stringWithFormat:@"%d",pageSize],
                         @"targetBrokerId":targetBrokerId,
                         };
    return [super doGet:KUrlConfig method:RESOURCE_BROKER_SCORE params:dict result:result];
};

//经纪人房子列表
-(AFHTTPRequestOperationManager *) brokerHouseList : (NSString *) brokerId result : (Result) result{
    NSDictionary *dict=@{
                         @"pageSize":@1,
                         @"brokerId":brokerId,
                         };
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE params:dict result:result];
};

-(AFHTTPRequestOperationManager *) submitBrokerComment : (NSString *) commentId result : (Result) result{
    NSDictionary *dict=@{@"commentId":commentId};
    return [super doPut:KUrlConfig method:COOPERATION_HOUSE_COMMENT params:dict result:result];
};

//邀请人脉
-(AFHTTPRequestOperationManager *) inviteFriend : (NSString *) sid receiverName : (NSString *) name receiverMobilephone : (NSNumber *) mobilephone content : (NSString *) content result : (Result) result{
    NSDictionary *dict=@{
                         @"sid":sid,
                         @"receiverName":name,
                         @"receiverMobilephone":mobilephone,
                         @"content":content
                         };
    return [super doPost:KUrlConfig method:LINK_INVITE_SMS params:dict result:result];
};

//没有过滤条件的房子列表
-(AFHTTPRequestOperationManager *) houseListWithoutFilter : (NSString *) brokerId tradeType : (NSInteger) tradeType pageNo : (NSInteger) pageNo result : (Result) result{
    NSDictionary *data=@{
                         @"tradeType":[NSString stringWithFormat:@"%d",tradeType],
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"brokerId":brokerId,
                         };
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE params:data result:result];
};

//附近房子
-(AFHTTPRequestOperationManager *) nearbyHouseList : (NSString *)regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo tradeType : (NSInteger) tradeType sort : (NSString *) sort pageNo : (NSInteger) pageNo pt : (NSString *) pt d : (NSString *) d result : (Result) result{
    NSDictionary *data=@{
                         @"regionId": regionId,
                         @"priceFrom": priceFrom,
                         @"priceTo": priceTo,
                         @"areaFrom": areaFrom,
                         @"areaTo": areaTo,
                         @"roomFrom": roomFrom,
                         @"roomTo": roomTo,
                         @"tradeType":[NSString stringWithFormat:@"%d",tradeType],
                         @"sort": sort,
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"pt":pt,
                         @"d":d,
                         };
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE params:data result:result];
};

-(AFHTTPRequestOperationManager *) requestHotHouseList : (NSString *) sid cityId : (NSString *)cityId result : (Result) result {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[super replaceNilString:sid] forKey:@"sid"];
    [dict setObject:[super replaceNilString:cityId] forKey:@"cityId"];
    return [super doGet:KUrlConfig method:@"house/hot" params:dict result:result];
};

@end
