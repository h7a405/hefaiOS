//
//  BaseClass.m
//
//  Created by   on 14-10-8
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BrokerCommentBean.h"
#import "NSObject+Json.h"

NSString *const KBrokerCommentModelContent = @"content";
NSString *const KBrokerCommentModelBrokerId = @"brokerId";
NSString *const KBrokerCommentModelId = @"id";
NSString *const KBrokerCommentModelTargetBrokerName = @"targetBrokerName";
NSString *const KBrokerCommentModelTargetBrokerId = @"targetBrokerId";
NSString *const KBrokerCommentModelTargetBrokerHeadImg = @"targetBrokerHeadImg";
NSString *const KBrokerCommentModelUsefulCount = @"usefulCount";
NSString *const KBrokerCommentModelCooperationId = @"cooperationId";
NSString *const KBrokerCommentModelScoreHouseTruth = @"scoreHouseTruth";
NSString *const KBrokerCommentModelScoreService = @"scoreService";
NSString *const KBrokerCommentModelCreateTime = @"createTime";



@implementation BrokerCommentBean

@synthesize content = _content;
@synthesize brokerId = _brokerId;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize targetBrokerName = _targetBrokerName;
@synthesize targetBrokerId = _targetBrokerId;
@synthesize targetBrokerHeadImg = _targetBrokerHeadImg;
@synthesize usefulCount = _usefulCount;
@synthesize cooperationId = _cooperationId;
@synthesize scoreHouseTruth = _scoreHouseTruth;
@synthesize scoreService = _scoreService;
@synthesize createTime = _createTime;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.content = [self objectOrNilForKey:KBrokerCommentModelContent fromDictionary:dict];
        self.brokerId = [self objectOrNilForKey:KBrokerCommentModelBrokerId fromDictionary:dict] ;
        self.internalBaseClassIdentifier = [self objectOrNilForKey:KBrokerCommentModelId fromDictionary:dict] ;
        self.targetBrokerName = [self objectOrNilForKey:KBrokerCommentModelTargetBrokerName fromDictionary:dict];
        self.targetBrokerId = [self objectOrNilForKey:KBrokerCommentModelTargetBrokerId fromDictionary:dict] ;
        self.usefulCount = [self objectOrNilForKey:KBrokerCommentModelUsefulCount fromDictionary:dict] ;
        self.cooperationId = [self objectOrNilForKey:KBrokerCommentModelCooperationId fromDictionary:dict] ;
        self.scoreHouseTruth = [self objectOrNilForKey:KBrokerCommentModelScoreHouseTruth fromDictionary:dict] ;
        self.scoreService = [self objectOrNilForKey:KBrokerCommentModelScoreService fromDictionary:dict] ;
        self.createTime = [self objectOrNilForKey:KBrokerCommentModelCreateTime fromDictionary:dict] ;
        self.targetBrokerHeadImg =[NSString stringWithFormat:@"%@",[Tool imageUrlWithPath:[self objectOrNilForKey:KBrokerCommentModelTargetBrokerHeadImg fromDictionary:dict] andTypeString:@"D03"]];
    }
    
    return self;
    
}




@end
