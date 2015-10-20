//
//  CooperationWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CooperationWsImpl.h"

@implementation CooperationWsImpl

//请求合作列表
-(AFHTTPRequestOperationManager *) cooperationList : (NSString *) brokerId object : (NSString *) object pageNo : (NSInteger) pageNo sid : (NSString *) sid result : (Result) result {
    NSDictionary *dict=@{
                         @"status":@"4",
                         @"object":object,
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"sid":sid,
                         @"brokerId":brokerId
                         };
    return [super doGet:KUrlConfig method:COOPERATION_HOUSE params:dict result:result];
};

//修改合作状态
-(AFHTTPRequestOperationManager *) changeCooperationState : (NSString *) cooperationId sid : (NSString *) sid status : (NSString *) status result : (Result) result {
    NSDictionary *dict=@{
                         @"cooperationId":cooperationId,
                         @"sid":sid,
                         @"status":status
                         };
    return [super doPut:KUrlConfig method:COOPERATION_HOUSE params:dict result:result];
};

//投诉合作
-(AFHTTPRequestOperationManager *) cooperationComplaint : (NSString *) cooperationId sid : (NSString *) sid content : (NSString *) content targetBrokerId : (NSString *) brokerId result : (Result) result{
    NSDictionary *dict=@{
                         @"cooperationId":cooperationId,
                         @"sid":sid,
                         @"content":content,
                         @"targetBrokerId":brokerId
                         };
    return [super doPost:KUrlConfig method:COOPERATION_HOUSE_COMPLAINT params:dict result:result];
};

//提交合作评价
-(AFHTTPRequestOperationManager *) submitCooperationScore : (NSString *) cooperationId sid : (NSString *) sid content : (NSString *) content consistentLevel : (NSInteger)consistentLevel serviceLevel : (NSInteger) serviceLevel result : (Result) result{
    NSDictionary *dict=@{
                         @"cooperationId":cooperationId,
                         @"sid":sid,
                         @"content":content,
                         @"consistentLevel":@(consistentLevel),
                         @"serviceLevel":@(serviceLevel),
                         };
    return [super doPost:KUrlConfig method:COOPERATION_HOUSE_COMMENT params:dict result:result];
};

@end
