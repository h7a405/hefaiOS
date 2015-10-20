//
//  Images.h
//
//  Created by Gram on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NearbyBrokerBean : NSObject

@property (nonatomic, copy) NSString *linkId; //人脉编号
@property (nonatomic, copy) NSString *linkUserId; //人脉所属成员ID
@property (nonatomic, copy) NSString *memberUserId; //成员用户ID
@property (nonatomic, copy) NSString *memberName; //成员名字
@property (nonatomic, copy) NSString *memberStore; //成员门店
@property (nonatomic, copy) NSString *memberMobilephone; //成员手机
@property (nonatomic, copy) NSString *scoreHouseTruth; //房源真实评分
@property (nonatomic, copy) NSString *scoreService; //服务态度评分
@property (nonatomic, copy) NSURL *memberHeaderImage; //成员头像

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
