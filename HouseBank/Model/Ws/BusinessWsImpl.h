//
//  BusinessWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface BusinessWsImpl : BaseWs

//请求商业地产
-(AFHTTPRequestOperationManager *) requestHouseListForBusiness : (NSInteger) pageNo tradeType : (NSString *) tradeType purpose : (NSString *) purpose kw : (NSString *) kw regionId : (NSString *) regionId priceFrom : (NSString *) priceFrom priceTo : (NSString *) priceTo areaFrom : (NSString *) areaFrom areaTo : (NSString *) areaTo sort : (NSString *) sort result : (Result) result;

-(AFHTTPRequestOperationManager *) submitDeveloperHouse : (NSString *) communityName communityAddress : (NSString *) communityAddress coverArea : (NSString *) area unitCount : (NSString *) unitCount avgPrice : (NSString *) avgPrice companyName : (NSString *) companyName consignorName : (NSString *) consignorName consignorPosition : (NSString *)consignorPosition linkPhone1 : (NSString *) linkPhone1 linkPhone2 : (NSString *) linkPhone2 remark : (NSString *) remark cityId : (NSString *) cityId regionId : (NSString *) regionId blockId : (NSString *) blockId result : (Result) result;

-(AFHTTPRequestOperationManager *) submitUserDelegation : (NSString *) tradetype purpose : (NSString *) purpose consignorName : (NSString *) consignorName consignorAge : (NSString *) consignorAge consignorGender : (NSString *) sex linkPhone1 : (NSString *) linkPhone1 linkPhone2 : (NSString *) linkPhone2 remark:(NSString *) remark cityId : (NSString *) cityId regionId : (NSString *) regionId blockId : (NSString *) blockId result : (Result) result;

@end
