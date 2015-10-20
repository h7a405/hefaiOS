//
//  InviteHistory.m
//  HouseBank
//
//  Created by Gram on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "InviteHistoryFriendsBean.h"
#import "NSDictionary+String.h"
#import "NSObject+Json.h"

NSString *const k_requestId = @"requestId"; //请求号
NSString *const k_sendUserName = @"sendUserName"; //发送用户姓名
NSString *const k_companyName = @"companyName"; //发送用户公司名
NSString *const k_storeName = @"storeName"; //发送用户门店名
NSString *const k_mobilephone = @"mobilephone"; //发送用户电话
NSString *const k_sendDate = @"sendDate"; //发送时间
NSString *const k_status = @"status"; //请求状态
NSString *const k_headImagePath = @"headImagePath"; //请求用户头像


@implementation InviteHistoryFriendsBean

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:[dict allStringObjDict]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.requestId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_requestId fromDictionary:dict]];
        self.sendUserName =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_sendUserName fromDictionary:dict]];
        self.companyName =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_companyName fromDictionary:dict]];
        self.storeName =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_storeName fromDictionary:dict]];
        self.mobilephone =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_mobilephone fromDictionary:dict]];
        self.sendDate =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_sendDate fromDictionary:dict]];
        self.status =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:k_status fromDictionary:dict]];
        self.headImagePath = [Tool imageUrlWithPath:[self objectOrNilForKey:k_headImagePath fromDictionary:dict] andTypeString:@"D01"];
    }
    return self;
}



@end
