//
//  NewHouseWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface NewHouseWsImpl : BaseWs

//请求新房数据
-(AFHTTPRequestOperationManager *) requestNewHouse : (NSInteger) pageNo pageSize : (NSInteger) pageSize result : (Result) result ;

//请求新房信息
-(AFHTTPRequestOperationManager *) requestHouseInfo : (NSString *) projectId result : (Result) result;

//请求新房房型
-(AFHTTPRequestOperationManager *) requestHouseModel : (NSString *) communityId result : (Result) result;

//提交新房预约
-(AFHTTPRequestOperationManager *) submitOrder : (NSString *) sid projectId : (NSString *) projectId name : (NSString *) name phone : (NSString *) phone result : (Result) result ;

//请求Award
-(AFHTTPRequestOperationManager *) requestAward : (NSString *) projectId result : (Result) result;

@end
