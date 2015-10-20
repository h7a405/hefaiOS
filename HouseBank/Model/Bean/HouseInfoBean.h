//
//  BaseClass.h
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HouseInfoBean : NSObject
@property (nonatomic, copy) NSString *brokerId;
@property (nonatomic, copy) NSString * livingRooms;
@property (nonatomic, copy) NSString * totalFloor;
@property (nonatomic, copy) NSString * totalPrice;
@property (nonatomic, copy) NSString *advTitle;
@property (nonatomic, copy) NSString * leftCommission;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * exclusiveDelegate;
@property (nonatomic, copy) NSString * tradeType;
@property (nonatomic, copy) NSString * toward;
@property (nonatomic, copy) NSString * advDesc;
@property (nonatomic, copy) NSString * bedRooms;
@property (nonatomic, copy) NSString * houseFloor;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, copy) NSString * buildYear;
@property (nonatomic, copy) NSString * buildArea;
@property (nonatomic, copy) NSString * decorationState;
@property (nonatomic, copy) NSString * sellerDivided;
@property (nonatomic, copy) NSString * houseId;
@property (nonatomic, copy) NSString * purpose;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * rightCommission;
@property (nonatomic, copy) NSString * buyerDivided;

+ (instancetype)houseInfoBeanWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
