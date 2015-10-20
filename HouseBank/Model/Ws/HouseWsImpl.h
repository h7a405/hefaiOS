//
//  HouseWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

//二手房和租房的网络访问类
@interface HouseWsImpl : BaseWs

//从服务器请求房子列表
-(AFHTTPRequestOperationManager *) loadHouse : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo tradeType : (NSInteger) tradeType sort : (NSString *) sort pageNo : (NSInteger) pageNo kw : (NSString *) kw  purpose : (NSInteger) purpose result : (void(^)(BOOL isSuccess , id result,NSString* data)) result ;

//从服务器请求房子搜索列表
-(AFHTTPRequestOperationManager *) loadHouseForSearch : (NSString *) kw pageSize : (NSString *) pageSize regionId : (NSString *) regionId result : (Result) result;

//根据houseid请求房子详细信息
-(AFHTTPRequestOperationManager *) loadHouseInfoByHouseId : (NSString *) houseId sid : (NSString*) sid result : (Result) result;

//根据小区id请求小区详细信息
-(AFHTTPRequestOperationManager *) loadCommunityInfoByCommunityId : (NSString *) communityId result : (Result) result;

//查询房子被查看次数
-(AFHTTPRequestOperationManager *) loadHouseCheckCount : (NSString *) houseId brokerId : (NSString *) brokerId result : (Result) result;

//看房申请
-(AFHTTPRequestOperationManager *) applyForCheckHouse : (NSString *) houseId brokerId : (NSString *) brokerId sid : (NSString *) sid result : (Result) result;

//经纪人用户评价
-(AFHTTPRequestOperationManager *) brokerScore : (NSString *) brokerId pageNo : (NSInteger) pageNo pageSize : (NSInteger) pageSize targetBrokerId : (NSString *) brokerId result : (Result) result ;

//经纪人房子列表
-(AFHTTPRequestOperationManager *) brokerHouseList : (NSString *) brokerId result : (Result) result;

//提交经纪人评价
-(AFHTTPRequestOperationManager *) submitBrokerComment : (NSString *) commentId result : (Result) result;

//邀请人脉
-(AFHTTPRequestOperationManager *) inviteFriend : (NSString *) sid receiverName : (NSString *) name receiverMobilephone : (NSNumber *) mobilephone content : (NSString *) content result : (Result) result ;

//没有过滤条件的房子列表
-(AFHTTPRequestOperationManager *) houseListWithoutFilter : (NSString *) brokerId tradeType : (NSInteger) tradeType pageNo : (NSInteger) pageNo result : (Result) result;

//附近房子
-(AFHTTPRequestOperationManager *) nearbyHouseList : (NSString *)regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo roomFrom : (NSString *) roomFrom roomTo : (NSString *) roomTo tradeType : (NSInteger) tradeType sort : (NSString *) sort pageNo : (NSInteger) pageNo pt : (NSString *) pt d : (NSString *) d result : (Result) result;

-(AFHTTPRequestOperationManager *) requestHotHouseList : (NSString *) sid cityId : (NSString *)cityId result : (Result) result ;

@end
