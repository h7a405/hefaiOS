//
//  BaseClass.h
//
//  Created by   on 14-10-8
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BrokerCommentBean : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString * brokerId;
@property (nonatomic, copy) NSString * internalBaseClassIdentifier;
@property (nonatomic, copy) NSString *targetBrokerName;
@property (nonatomic, copy) NSString * targetBrokerId;
@property (nonatomic, copy) NSString * targetBrokerHeadImg;
@property (nonatomic, copy) NSString * usefulCount;
@property (nonatomic, copy) NSString * cooperationId;
@property (nonatomic, copy) NSString * scoreHouseTruth;
@property (nonatomic, copy) NSString * scoreService;
@property (nonatomic, copy) NSString * createTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
