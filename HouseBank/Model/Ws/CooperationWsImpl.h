//
//  CooperationWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface CooperationWsImpl : BaseWs

//请求合作列表
-(AFHTTPRequestOperationManager *) cooperationList : (NSString *) brokerId object : (NSString *) object pageNo : (NSInteger) pageNo sid : (NSString *) sid result : (Result) result ;

//修改合作状态
-(AFHTTPRequestOperationManager *) changeCooperationState : (NSString *) cooperationId sid : (NSString *) sid status : (NSString *) status result : (Result) result ;

//投诉合作
-(AFHTTPRequestOperationManager *) cooperationComplaint : (NSString *) cooperationId sid : (NSString *) sid content : (NSString *) content targetBrokerId : (NSString *) brokerId result : (Result) result;

//提交合作评价
-(AFHTTPRequestOperationManager *) submitCooperationScore : (NSString *) cooperationId sid : (NSString *) sid content : (NSString *) content consistentLevel : (NSInteger)consistentLevel serviceLevel : (NSInteger) serviceLevel result : (Result) result;

@end
