//
//  ReleaseWsImpl.m
//  HouseBank
//
//  Created by CSC on 15/1/19.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "ReleaseWsImpl.h"

@implementation ReleaseWsImpl

//发布出售
-(AFHTTPRequestOperationManager *) updateHouseSale : (NSDictionary *) params result : (Result) result {
    return [super doPost:KUrlConfig method:@"house/add" params:params result:result];
};

@end
