//
//  BrokerInfoModel.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerInfoBean : NSObject

@property (nonatomic)NSNumber *authStatus ;
@property (nonatomic)NSNumber *blockId ;
@property (nonatomic)NSString *brokerHeadImg ;
@property (nonatomic)NSNumber *brokerId ;
@property (nonatomic)NSString *company ;
@property (nonatomic)NSNumber *companyId ;
@property (nonatomic)NSString *familiarBlock ;
@property (nonatomic)NSString *familiarCommunity ;
@property (nonatomic)NSNumber *mobilephone ;
@property (nonatomic)NSString *name ;
@property (nonatomic)NSString *region ;
@property (nonatomic)NSNumber *regionId ;
@property (nonatomic)NSString *resume ;
@property (nonatomic)NSString *store ;
@property (nonatomic)NSNumber *storeId ;
@property (nonatomic)NSNumber *workYear ;
@property (nonatomic)NSString *cityId;

+(BrokerInfoBean *) brokerFromDic : (NSDictionary *) dic;

@end
