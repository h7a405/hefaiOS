//
//  LoginWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

//登陆界面网络连接实现
@interface LoginWsImpl : BaseWs

//登录
-(AFHTTPRequestOperationManager *) login : (NSString *) userName password : (NSString *) password result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//注册
- (AFHTTPRequestOperationManager *)registMemberWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andResult:(void(^)(BOOL isSuccess, id result, NSString *data))result;

//- (AFHTTPRequestOperationManager *)registDistributeCharacterWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andApplyChainId:(NSInteger)applyChainId andIdentity:(NSString *)idNumber andImagePath:(NSString *)imagePath andApplyPrice:(NSString *)applyPrice andResult:(void(^)(BOOL isSuccess, id result, NSString *data))result;

- (AFHTTPRequestOperationManager *)registDistributeCharacterWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andApplyChainId:(NSString *)applyChainId andIdentity:(NSString *)idNumber andApplyPrice:(NSString *)applyPrice andImage:(NSString *)imagePath andResult:(void (^)(BOOL, id, NSString *))result;

-(AFHTTPRequestOperationManager *) registerBroker : (NSString *) number name : (NSString *) name password : (NSString *) password cityId : (NSString *) cityId regionId : (NSString *) regionId brokerId : (NSString *) brokerId result : (void(^)(BOOL isSuccess , id result,NSString* data)) result ;


@end
