//
//  LoginWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "LoginWsImpl.h"

@implementation LoginWsImpl

-(AFHTTPRequestOperationManager *) login : (NSString *) userName password : (NSString *) password result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *params=@{@"username": userName,@"password": password};
    return [super doGet:KUrlConfig method: @"user/login" params:params result:result];
};

-(AFHTTPRequestOperationManager *) registerBroker : (NSString *) number name : (NSString *) name password : (NSString *) password cityId : (NSString *) cityId regionId : (NSString *) regionId brokerId : (NSString *) brokerId result : (void(^)(BOOL isSuccess , id result,NSString* data)) result {
    NSDictionary *params=@{@"mobilephone":number,
                           @"name" : name,
                           @"password":password,
                           @"cityId":cityId,
                           @"regionId":regionId,
                           @"blockId":brokerId};
    return [super doPost:KUrlConfig method:RESOURCE_BROKER params:params result:result];
};

- (AFHTTPRequestOperationManager *)registMemberWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andResult:(void (^)(BOOL, id, NSString *))result{
    
    NSMutableDictionary *dic_params_temp = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobilePhone, @"mobilephone",
                             name, @"name",
                             password, @"password",
                             cityId, @"cityId",
                             regionId, @"regionId",
                             blockId, @"blockId",
                                            nil];
    if(recommendCode){
        [dic_params_temp setObject:recommendCode forKey:@"recommendCode"];
    }
    if(recommendPhone && recommender){
//        [dic_params_temp setObject:@"刘全" forKey:@"recommender"];
//        [dic_params_temp setObject:@"18521512344" forKey:@"recommenderPhone"];
        [dic_params_temp setObject:recommender forKey:@"recommender"];
        [dic_params_temp setObject:recommendPhone forKey:@"recommenderPhone"];
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:dic_params_temp];
//    NSDictionary *params = @{@"mobilephone":mobilePhone,
//                             @"name" : name,
//                             @"password":password,
//                             @"cityId":cityId,
//                             @"regionId":regionId,
//                             @"blockId":blockId,
//                             @"recommender":@"刘全",
//                             @"recommenderPhone":@"18521512344"};
    NSLog(@"%s || params:%@", __FUNCTION__, params);
    return [super doPost:KUrlConfig method:RESOURCE_BROKER params:params result:result];
}

//- (AFHTTPRequestOperationManager *)registDistributeCharacterWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andApplyChainId:(NSInteger)applyChainId andIdentity:(NSString *)idNumber andImagePath:(NSString *)imagePath andApplyPrice:(NSString *)applyPrice andResult:(void (^)(BOOL, id, NSString *))result{
//    
//    NSMutableDictionary *dic_params_temp = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobilePhone, @"mobilephone",
//                                            name, @"name",
//                                            password, @"password",
//                                            cityId, @"cityId",
//                                            regionId, @"regionId",
//                                            blockId, @"blockId",
//                                            idNumber, @"identity",
//                                            nil];
//    if(recommendCode){
//        [dic_params_temp setObject:recommendCode forKey:@"recommendCode"];
//    }
//    if(recommendPhone && recommender){
//        [dic_params_temp setObject:recommender forKey:@"recommender"];
//        [dic_params_temp setObject:recommendPhone forKey:@"recommendPhone"];
//    }
//    if(applyPrice){
//        [dic_params_temp setObject:applyPrice forKey:@"applyPrice"];
//    }
//    NSDictionary *params = [NSDictionary dictionaryWithDictionary:dic_params_temp];
//    return [super doPost:KUrlConfig method:RESOURCE_REGCHAIN params:params result:result];
//}

- (AFHTTPRequestOperationManager *)registDistributeCharacterWithPhone:(NSString *)mobilePhone andPassword:(NSString *)password andRealname:(NSString *)name andCityId:(NSString *)cityId andRegionId:(NSString *)regionId andBlockId:(NSString *)blockId andRecommender:(NSString *)recommender andRecommendPhone:(NSString *)recommendPhone andRecommendCode:(NSString *)recommendCode andApplyChainId:(NSString *)applyChainId andIdentity:(NSString *)idNumber andApplyPrice:(NSString *)applyPrice andImage:(NSString *)imagePath andResult:(void (^)(BOOL, id, NSString *))result{
    NSMutableDictionary *dic_params_temp = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobilePhone, @"mobilephone",
                                            name, @"name",
                                            password, @"password",
                                            cityId, @"cityId",
                                            regionId, @"regionId",
                                            blockId, @"blockId",
                                            idNumber, @"identity",
                                            applyChainId, @"applyChainId",
                                            imagePath, @"imagePath",
                                            nil];
    if(recommendCode){
        [dic_params_temp setObject:recommendCode forKey:@"recommendCode"];
    }
    if(recommendPhone && recommender){
        [dic_params_temp setObject:recommender forKey:@"recommender"];
        [dic_params_temp setObject:recommendPhone forKey:@"recommenderPhone"];
//        [dic_params_temp setObject:@"刘全" forKey:@"recommender"];
//        [dic_params_temp setObject:@"18521512344" forKey:@"recommenderPhone"];
    }
    if(applyPrice){
        [dic_params_temp setObject:applyPrice forKey:@"applyPrice"];
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:dic_params_temp];
    NSLog(@"%s || params:%@", __FUNCTION__, params);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:KUrlConfig]];
//    manager.requestSerializer.timeoutInterval = 15.0;
//    [manager POST:RESOURCE_REGCHAIN parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData *data=UIImagePNGRepresentation(image);
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//        [formData appendPartWithFileData:data name:@"logo_img" fileName:fileName mimeType:@"image/png"];
//        
//    } success:^(AFHTTPRequestOperation *operation , id responseObject){
//        result(YES,responseObject,operation.responseString);
//    }failure:^(AFHTTPRequestOperation *operation , NSError * error){
//        result(NO,error,operation.responseString);
//        
//    }];
        [manager PUT:RESOURCE_REGCHAIN parameters:params success:^(AFHTTPRequestOperation *operation , id responseObject){
                    result(YES,responseObject,operation.responseString);
                }failure:^(AFHTTPRequestOperation *operation , NSError * error){
                    result(NO,error,operation.responseString);
    
                }];
    return manager;
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    NSString *URLString = [NSString stringWithFormat:@"%@%@", KUrlConfig, RESOURCE_REGCHAIN];
//    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"imagePath" fileName:[NSString stringWithFormat:@"IDcardImage-%@", mobilePhone] mimeType:@"image/jpeg"];
//    }];
//
//    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        result(YES,responseObject,operation.responseString);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        result(NO,error,operation.responseString);
//    }];
//    
//    // fire the request
//    [requestOperation start];
//    return manager;
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:KUrlConfig]];
//    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    
//    // need to pass the full URLString instead of just a path like when using 'PUT' or 'POST' convenience methods
//    NSString *URLString = [NSString stringWithFormat:@"%@%@", KUrlConfig, RESOURCE_REGCHAIN];
//    NSLog(@"%s || %@", __FUNCTION__, URLString);
//    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"imagePath" fileName:@"highlight_image.jpg" mimeType:@"image/jpeg"];
//    }];
//    
//    // 'PUT' and 'POST' convenience methods auto-run, but HTTPRequestOperationWithRequest just
//    // sets up the request. you're responsible for firing it.
//    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        result(YES,responseObject,operation.responseString);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        result(NO,error,operation.responseString);
//    }];
//    
//    // fire the request
//    [requestOperation start];
//    return manager;
}



@end
