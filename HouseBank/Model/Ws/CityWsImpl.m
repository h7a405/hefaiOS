//
//  CityWs.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CityWsImpl.h"

@implementation CityWsImpl

-(AFHTTPRequestOperationManager *) citys : (void(^)(BOOL isSuccess , id result,NSString* data)) result {
    return [super doGet:KUrlConfig method:RESOURCE_REGION params:nil result:result];
};

@end
