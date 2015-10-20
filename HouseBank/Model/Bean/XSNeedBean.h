//
//  BaseClass.h
//
//  Created by   on 14-10-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSNeedBean : NSObject

@property (nonatomic, copy) NSString * bedRoom;
@property (nonatomic, copy) NSString * houseFloorTo;
@property (nonatomic, copy) NSString * facilities;
@property (nonatomic, copy) NSString *blockIdMap;
@property (nonatomic, copy) NSString * paymentType;
@property (nonatomic, copy) NSString * tradeType;
@property (nonatomic, copy) NSString * areaFrom;
@property (nonatomic, copy) NSString *blockNameMap;
@property (nonatomic, copy) NSString * priceFrom;
@property (nonatomic, copy) NSString * houseFloorFrom;
@property (nonatomic, copy) NSString * priceTo;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *communityidMap;
@property (nonatomic, copy) NSString * houseType;
@property (nonatomic, copy) NSString * decorationState;
@property (nonatomic, copy) NSString *customerMobilephone;
@property (nonatomic, copy) NSString * purpose;
@property (nonatomic, copy) NSString * targetFormat;
@property (nonatomic, copy) NSString * reqId;
@property (nonatomic, copy) NSString *communityNameMap;
@property (nonatomic, copy) NSString * areaTo;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * createUserId;
@property (nonatomic, copy) NSString * toward;
@property (nonatomic, copy) NSString *customerName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
