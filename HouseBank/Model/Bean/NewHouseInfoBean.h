//
//  BaseClass.h
//
//  Created by   on 14-9-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewHouseInfoBean : NSObject

@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString * propertyYear;
@property (nonatomic, copy) NSString * hotPoint;
@property (nonatomic, copy) NSString * deliverDate;
@property (nonatomic, copy) NSString *propertyType;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString *averagePrice;
@property (nonatomic, copy) NSString *commissionRate;
@property (nonatomic, copy) NSString * openDate;
@property (nonatomic, copy) NSString * greeningRate;
@property (nonatomic, copy) NSString *brokerLinkman;
@property (nonatomic, copy) NSString * projectId;
@property (nonatomic, copy) NSString * volumeRate;
@property (nonatomic, copy) NSString * decoration;
@property (nonatomic, copy) NSString *developer;
@property (nonatomic, copy) NSString *manageFee;
@property (nonatomic, copy) NSString *brokerPhone;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *customerDiscount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
