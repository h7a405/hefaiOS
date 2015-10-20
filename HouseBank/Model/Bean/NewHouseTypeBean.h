//
//  BaseClass.h
//
//  Created by   on 14-9-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewHouseTypeBean : NSObject

@property (nonatomic, copy) NSString * livingRooms;
@property (nonatomic, copy) NSString * unitId;
@property (nonatomic, strong) NSURL * imagePath;
@property (nonatomic, copy) NSString * toward;
@property (nonatomic, copy) NSString * hotPoint;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * sellStatus;
@property (nonatomic, copy) NSString * averagePrice;
@property (nonatomic, copy) NSString * bedRooms;
@property (nonatomic, copy) NSString * purpose;
@property (nonatomic, copy) NSString * unitName;
@property (nonatomic, copy) NSString * washRooms;
@property (nonatomic, copy) NSString * createUserId;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * buildArea;
@property (nonatomic, copy) NSString * mainUnit;
@property (nonatomic, copy) NSString * unitCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
