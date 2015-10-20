//
//  BusinessWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BusinessWsImpl.h"
#import "Constants.h"

@implementation BusinessWsImpl

//请求商业地产
-(AFHTTPRequestOperationManager *) requestHouseListForBusiness : (NSInteger) pageNo tradeType : (NSString *) tradeType purpose : (NSString *) purpose kw : (NSString *) kw regionId : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo sort : (NSString *) sort result:(Result)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [params setObject:[self replaceNilString:tradeType] forKey:@"tradeType"];
    [params setObject:[self replaceNilString:purpose] forKey:@"purpose"];
    [params setObject:[self replaceNilString:purpose] forKey:@"kw"];
    [params setObject:[self replaceNilString:regionId] forKey:@"regionId"];
    [params setObject:[self replaceNilString:priceFrom] forKey:@"priceFrom"];
    [params setObject:[self replaceNilString:priceTo] forKey:@"priceTo"];
    [params setObject:[self replaceNilString:areaFrom] forKey:@"areaFrom"];
    [params setObject:[self replaceNilString:areaTo] forKey:@"areaTo"];
    [params setObject:[self replaceNilString:sort] forKey:@"sort"];
    
    NSLog(@"%@",params);
    
    return [super doGet:KUrlConfig method:RESOURCE_HOUSE params:params result:result];
};


-(AFHTTPRequestOperationManager *) submitDeveloperHouse : (NSString *) communityName communityAddress : (NSString *) communityAddress coverArea : (NSString *) area unitCount : (NSString *) unitCount avgPrice : (NSString *) avgPrice companyName : (NSString *) companyName consignorName : (NSString *) consignorName consignorPosition : (NSString *)consignorPosition linkPhone1 : (NSString *) linkPhone1 linkPhone2 : (NSString *) linkPhone2 remark : (NSString *) remark cityId : (NSString *) cityId regionId : (NSString *) regionId blockId : (NSString *) blockId result:(Result)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:communityName forKey:@"communityName"];
    [params setObject:communityAddress forKey:@"communityAddress"];
    [params setObject:area forKey:@"coverArea"];
    [params setObject:unitCount forKey:@"unitCount"];
    [params setObject:avgPrice forKey:@"avgPrice"];
    [params setObject:companyName forKey:@"companyName"];
    [params setObject:consignorName forKey:@"consignorName"];
    [params setObject:consignorPosition forKey:@"consignorPosition"];
    [params setObject:linkPhone1 forKey:@"linkPhone1"];
    [params setObject:linkPhone2 forKey:@"linkPhone2"];
    [params setObject:remark forKey:@"remark"];
    [params setObject:cityId forKey:@"cityId"];
    [params setObject:regionId forKey:@"regionId"];
    [params setObject:blockId forKey:@"blockId"];
    
    return [super doPost:KUrlConfig method:@"commissioned/newHouse/add" params:params result:result];
};

-(AFHTTPRequestOperationManager *) submitUserDelegation : (NSString *) tradetype purpose : (NSString *) purpose consignorName : (NSString *) consignorName consignorAge : (NSString *) consignorAge consignorGender : (NSString *) sex linkPhone1 : (NSString *) linkPhone1 linkPhone2 : (NSString *) linkPhone2 remark:(NSString *) remark cityId : (NSString *) cityId regionId : (NSString *) regionId blockId : (NSString *) blockId result : (Result) result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:consignorName forKey:@"consignorName"];
    [params setObject:linkPhone1 forKey:@"linkPhone1"];
    [params setObject:linkPhone2 forKey:@"linkPhone2"];
    [params setObject:remark forKey:@"remark"];
    [params setObject:cityId forKey:@"cityId"];
    [params setObject:regionId forKey:@"regionId"];
    [params setObject:blockId forKey:@"blockId"];
    [params setObject:tradetype forKey:@"tradetype"];
    [params setObject:purpose forKey:@"purpose"];
    [params setObject:consignorAge forKey:@"consignorAge"];
    [params setObject:sex forKey:@"consignorGender"];
    
    return [super doPost:KUrlConfig method:@"commissioned/house/add" params:params result:result];
};


@end
