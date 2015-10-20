//
//  FriendsWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FriendsWsImpl.h"

@implementation FriendsWsImpl

//搜索人脉
-(AFHTTPRequestOperationManager *) searchFriends : (NSString *) sid kw : (NSString *) kw pageNo : (NSInteger) pageNo pageSize : (NSInteger) pageSize result : (Result) result{
    NSDictionary *data=@{
                         @"sid": sid,
                         @"kw": [NSString stringWithFormat:@"%@",kw],
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"pageSize": [NSString stringWithFormat:@"%d",pageSize]
                         };
    return [super doGet:KUrlConfig method:RESOURCE_LINK_MEMBER params:data result:result];
};

// 邀请人脉历史
//请求类型"收到的=request/receive,发出的=linkinvite/send"
-(AFHTTPRequestOperationManager *) invitFriendsHistory : (NSString *) sid invitType:(NSInteger) type pageNo : (NSInteger) pageNo result : (Result) result {
    NSDictionary *data=@{
                         @"sid": sid,
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo]
                         };
    NSString *method = nil;
    if (type == Send) {
        method = @"linkinvite/send";
    }else{
        method = REQUEST_RECEIVE;
    }
    
    return [super doGet:KUrlConfig method:method params:data result:result];
};

//人脉邀请处理
-(AFHTTPRequestOperationManager *) friendsInvitHandle : (NSString *) sid requestId : (NSString *) requestId status : (NSInteger) status result : (Result) result {
    NSDictionary *data=@{
                         @"sid": sid,
                         @"requestId":requestId,
                         @"status": [NSString stringWithFormat: @"%d", status]
                         };
    return [super doPost:KUrlConfig method:REQUEST_OPERATE params:data result:result];
};

//请求附近的经纪人
-(AFHTTPRequestOperationManager *) requestNearbyBroker : (NSString *) sid pageNo : (NSInteger) pageNo pageSize : (NSInteger) pageSize result : (Result) result{
    NSDictionary *data=@{
                         @"sid": sid,
                         @"pageNo":[NSString stringWithFormat:@"%d",pageNo],
                         @"pageSize": [NSString stringWithFormat:@"%d",pageSize]
                         };
    return [super doGet:KUrlConfig method:RESOURCE_LINK_NEAR params:data result:result];
};

@end
