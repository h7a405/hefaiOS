//
//  Images.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "NearbyBrokerBean.h"
#import "NSObject+Json.h"

NSString *const kLinkId = @"linkId"; //人脉编号
NSString *const kLinkUserId = @"linkUserId"; //人脉所属成员ID
NSString *const kMemberUserId = @"memberUserId"; //成员用户ID
NSString *const kMemberName = @"memberName"; //成员名字
NSString *const kMemberStore = @"memberStore"; //成员门店
NSString *const kMemberMobilephone = @"memberMobilephone"; //成员手机
NSString *const kScoreHouseTruth = @"scoreHouseTruth"; //房源真实评分
NSString *const kScoreService = @"scoreService"; //服务态度评分
NSString *const kMemberHeaderImage = @"memberHeadImage"; //成员头像



@implementation NearbyBrokerBean

@synthesize linkId = _linkId;
@synthesize linkUserId = _linkUserId; //人脉所属成员ID
@synthesize memberUserId = _memberUserId; //成员用户ID
@synthesize memberName = _memberName; //成员名字
@synthesize memberStore = _memberStore; //成员门店
@synthesize memberMobilephone = _memberMobilephone; //成员手机
@synthesize scoreHouseTruth = _scoreHouseTruth; //房源真实评分
@synthesize scoreService = _scoreService; //服务态度评分
@synthesize memberHeaderImage = _memberHeaderImage; //成员头像


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.linkId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kLinkId fromDictionary:dict]];
        self.linkUserId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kLinkUserId fromDictionary:dict]];
        self.memberUserId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kMemberUserId fromDictionary:dict]];
        self.memberName =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kMemberName fromDictionary:dict]];
        self.memberStore =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kMemberStore fromDictionary:dict]];
        self.memberMobilephone =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kMemberMobilephone fromDictionary:dict]];
        self.scoreHouseTruth =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kScoreHouseTruth fromDictionary:dict]];
        self.scoreService =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kScoreService fromDictionary:dict]];
        self.memberHeaderImage =[Tool imageUrlWithPath:[self objectOrNilForKey:kMemberHeaderImage fromDictionary:dict] andTypeString:@"D01"];
    }
    return self;
}




@end
