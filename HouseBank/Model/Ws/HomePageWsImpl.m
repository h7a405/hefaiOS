//
//  HomePageWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomePageWsImpl.h"

@implementation HomePageWsImpl

-(AFHTTPRequestOperationManager *) article : (void(^)(BOOL isSuccess , id result,NSString* data)) result {
    return [super doGet:KUrlConfig method:RESOURCE_ARTICLE params:nil result:result];
};

@end
