//
//  BaseClass.h
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MoreInfos;

@interface CommunityBean : NSObject

@property (nonatomic, copy) NSString * blockId;
@property (nonatomic, copy) NSString *developerCorp;
@property (nonatomic, strong) MoreInfos *moreInfos;
@property (nonatomic, copy) NSString * propertyType;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * houseNum;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * regionId;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *community;
@property (nonatomic, copy) NSString *propertyCorp;
@property (nonatomic, copy) NSString *completionDate;

+ (instancetype)communityBeanWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
