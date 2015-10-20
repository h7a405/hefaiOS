//
//  BrokerDetailInfoModel.h
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerDetailInfoBean : NSObject

@property(nonatomic) NSNumber * brokerId;
@property(nonatomic) NSNumber * familiarBlock1;
@property(nonatomic) NSNumber * familiarBlock2;
@property(nonatomic) NSNumber * familiarBlock3;
@property(nonatomic) NSNumber * familiarBlock4;


@property(nonatomic) NSNumber * familiarCommunity1;
@property(nonatomic) NSNumber * familiarCommunity2;
@property(nonatomic) NSNumber * familiarCommunity3;
@property(nonatomic) NSNumber * familiarCommunity4;

@property(nonatomic) NSString * familiarCommunityName1;
@property(nonatomic) NSString * familiarCommunityName2;
@property(nonatomic) NSString * familiarCommunityName3;
@property(nonatomic) NSString * familiarCommunityName4;

+(BrokerDetailInfoBean*) brokerDetailByDic : (NSDictionary *) dic;

@end
