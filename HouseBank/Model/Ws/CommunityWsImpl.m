//
//  CommunityWsImpl.m
//  HouseBank
//
//  Created by CSC on 15/1/18.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "CommunityWsImpl.h"

@implementation CommunityWsImpl

-(AFHTTPRequestOperationManager *) requestCommunityList :(NSString *) areaId keyWord : (NSString *) keyWord result : (Result) result{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[TextUtil replaceNull:keyWord] forKey:@"kw"];
    [params setObject:[TextUtil replaceNull:areaId] forKey:@"regionId"];
    [params setObject:@"1" forKey:@"pageNo"];
    [params setObject:@"200" forKey:@"pageSize"];
    return [super doGet:KUrlConfig method:@"community" params:params result:result];
};

@end
