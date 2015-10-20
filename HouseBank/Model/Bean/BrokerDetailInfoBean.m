//
//  BrokerDetailInfoModel.m
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BrokerDetailInfoBean.h"
#import "ObjectUtil.h"

@implementation BrokerDetailInfoBean
@synthesize  brokerId;
@synthesize  familiarBlock1;
@synthesize  familiarBlock2;
@synthesize  familiarBlock3;
@synthesize  familiarBlock4;

@synthesize  familiarCommunity1;
@synthesize  familiarCommunity2;
@synthesize  familiarCommunity3;
@synthesize  familiarCommunity4;

@synthesize  familiarCommunityName1;
@synthesize  familiarCommunityName2;
@synthesize  familiarCommunityName3;
@synthesize  familiarCommunityName4;

+(BrokerDetailInfoBean *) brokerDetailByDic : (NSDictionary *) dic{
    return [ObjectUtil objFromDic:dic obj:[BrokerDetailInfoBean new]];
};

@end
