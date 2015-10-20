//
//  InviteHistory.h
//  HouseBank
//
//  Created by Gram on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteHistoryFriendsBean : NSObject
@property (nonatomic, copy) NSString *requestId; //请求号
@property (nonatomic, copy) NSString *sendUserName; //发送用户姓名
@property (nonatomic, copy) NSString *companyName; //发送用户公司名
@property (nonatomic, copy) NSString *storeName; //发送用户门店名
@property (nonatomic, copy) NSString *mobilephone; //发送用户电话
@property (nonatomic, copy) NSString *sendDate; //发送时间
@property (nonatomic, copy) NSString *status; //请求状态
@property (nonatomic, copy) NSURL *headImagePath; //请求用户头像

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
