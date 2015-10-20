//
//  BaseWs.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@implementation BaseWs

-(AFHTTPRequestOperationManager *) doGet:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result , NSString* data)) result{
    AFHTTPRequestOperationManager *afManger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSLog(@"%s || url: %@%@", __FUNCTION__, url, method);
    [afManger GET:method parameters:params success:^(AFHTTPRequestOperation *operation , id responseObject){
        result(YES,responseObject,operation.responseString);
    }failure:^(AFHTTPRequestOperation *operation , NSError * error){
        result(NO,error,operation.responseString);
    }];
    return afManger;
};

-(AFHTTPRequestOperationManager *) doPut:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result , NSString* data)) result{
    AFHTTPRequestOperationManager *afManger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    [afManger PUT:method parameters:params success:^(AFHTTPRequestOperation *operation , id responseObject){
        result(YES,responseObject,operation.responseString);
    }failure:^(AFHTTPRequestOperation *operation , NSError * error){
        result(NO,error,operation.responseString);
    }];
    return afManger;
};

-(AFHTTPRequestOperationManager *) doPost:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result ,NSString *data)) result{
    AFHTTPRequestOperationManager *afManger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        NSLog(@"%s || url: %@%@", __FUNCTION__, url, method);
    [afManger POST:method parameters:params success:^(AFHTTPRequestOperation *operation , id responseObject){
        result(YES,responseObject,operation.responseString);
    }failure:^(AFHTTPRequestOperation *operation , NSError * error){
        result(NO,error,operation.responseString);
    }];
    return afManger;
};

-(AFHTTPRequestOperationManager *) doDelete:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result ,NSString *data)) result {
    AFHTTPRequestOperationManager *afManger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    [afManger DELETE:method parameters:params success:^(AFHTTPRequestOperation *operation , id responseObject){
        result(YES,responseObject,operation.responseString);
    }failure:^(AFHTTPRequestOperation *operation , NSError * error){
        result(NO,error,operation.responseString);
    }];
    return afManger;
};

-(NSString *) replaceNilString :(NSString *) param {
    return param ? param : @"";
};

@end
