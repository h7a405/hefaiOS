//
//  BaseWs.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AFNetworking.h"
#import "Tool.h"

typedef void (^Result)(BOOL isSuccess , id result,NSString* data);

/**
 访问网络基类，该类提供Get、Post和Put方式
 */
@interface BaseWs : NSObject

-(AFHTTPRequestOperationManager *) doGet:(NSString *) url method:(NSString *) method params : (NSDictionary *) params  result : (void(^)(BOOL isSuccess , id result , NSString *data)) result ;
-(AFHTTPRequestOperationManager *) doPut:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result ,NSString *data)) result ;
-(AFHTTPRequestOperationManager *) doPost:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result ,NSString *data)) result ;
-(AFHTTPRequestOperationManager *) doDelete:(NSString *) url method:(NSString *) method  params : (NSDictionary *) params   result : (void(^)(BOOL isSuccess , id result ,NSString *data)) result ;

-(NSString *) replaceNilString :(NSString *) param ;

@end
