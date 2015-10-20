//
//  BaseClass.h
//
//  Created by   on 14-9-28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XSCooperationBean : NSObject

@property (nonatomic, copy) NSString *acceptMessage;
@property (nonatomic, strong)NSURL * brokerHeaderImg;
@property (nonatomic, copy) NSString * lookHouse;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * buyerPayment;
@property (nonatomic, copy) NSString * exclusiveDelegate;
@property (nonatomic, copy) NSString * sellerPayment;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *mobilephone;
@property (nonatomic, copy) NSString * applyUserId;
@property (nonatomic, copy) NSString * isFlagMy;
@property (nonatomic, copy) NSString *storeNameOne;
@property (nonatomic, copy) NSString *brokerInfoTow;
@property (nonatomic, copy) NSString *houseInfo;
@property (nonatomic, copy) NSString * cooperationId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString * commentCounts;
@property (nonatomic, copy) NSString * houseId;
@property (nonatomic, copy) NSString * superId;
@property (nonatomic, copy) NSString *showTime;
@property (nonatomic, copy) NSString * applyTime;
@property (nonatomic, copy) NSString * acceptComission;
@property (nonatomic, copy) NSString * recommend;
@property (nonatomic, copy) NSString * applyCommission;
@property (nonatomic, copy) NSString * acceptTime;
@property (nonatomic, copy) NSString *brokerInfo;
@property (nonatomic, copy) NSString *storeNameTow;
@property (nonatomic, copy) NSString * hasImage;
@property (nonatomic, copy) NSString *applyMessage;
@property (nonatomic, copy) NSString * acceptUserId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
