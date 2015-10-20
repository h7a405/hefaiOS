//
//  FriendsWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

#define Send 0
#define Receive 1

@interface FriendsWsImpl : BaseWs

//搜索人脉
-(AFHTTPRequestOperationManager *) searchFriends : (NSString *) sid kw : (NSString *) kw pageNo : (NSInteger) pageNo pageSize : (NSInteger)pageSize result : (Result) result;

// 邀请人脉历史
-(AFHTTPRequestOperationManager *) invitFriendsHistory : (NSString *) sid invitType : (NSInteger) type pageNo : (NSInteger) pageNo result : (Result) result ;

//人脉邀请处理
-(AFHTTPRequestOperationManager *) friendsInvitHandle : (NSString *) sid requestId : (NSString *) requestId status : (NSInteger) status result : (Result) result ;

//请求附近的经纪人
-(AFHTTPRequestOperationManager *) requestNearbyBroker : (NSString *) sid pageNo : (NSInteger) pageNo pageSize : (NSInteger) pageSize result : (Result) result ;

@end
